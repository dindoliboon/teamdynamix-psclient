#
# Sample-Set-PersonDisabled.ps1
#
# Set TeamDynamix users to inactive based on ActiveDirectory enabled status.
#
# Run Sample-New-ExcelImportTemplate.ps1 to create settings file first.
#
# Tested on Windows 10, PowerShell 5.0.10240.16384.
#

$Script:DebugPreference   = 'Continue'
$Script:VerbosePreference = 'Continue'

$UserNameFile       = "$PSScriptRoot\..\_secret\credentials-admin.username.txt"
$PasswordFile       = "$PSScriptRoot\..\_secret\credentials-admin.password.txt"
$BearerFile         = "$PSScriptRoot\..\_secret\credentials-admin.bearer.txt"
$SettingsFile       = "$PSScriptRoot\..\_secret\Sample-PersonImport.settings.txt"
$DisabledLDAPFilter = '(&(objectCategory=person)(objectClass=user)(userAccountControl:1.2.840.113556.1.4.803:=2)(mail=*))'

if ((Test-Path -Path $SettingsFile) -eq $true) {
    Import-Module -Name ActiveDirectory
    Import-Module -Name "$PSScriptRoot\..\teamdynamix-psclient"

    $Settings = Get-Content -Path $SettingsFile | ConvertFrom-Json

    $Bearer = New-TdpscCachedLoginSession -UserNameFile $UserNameFile -PasswordFile $PasswordFile -BearerFile $BearerFile -IsAdminCredential $true

    $disabledEmployeesAd = Get-ADUser -LDAPFilter $DisabledLDAPFilter -SearchBase $Settings.SearchBase -SearchScope Subtree -Properties sAMAccountName,mail
    $disabledEmployeesAd |% {
        $UserSearch = $Bearer | Get-TdpscRestrictedPersonSearch -SearchText $_.mail
        if ($UserSearch -ne $null) {
            $Person = Get-TdpscPerson -Bearer $Bearer -UID $UserSearch.UID
            if ($Person -ne $null -and $Person.UID -ne $null) {
                $Person.IsActive = $false
                $UpdatedPerson = Set-TdpscPerson -Bearer $Bearer -Person $Person
                $UpdatedPerson | Format-Table
            }
        }

        # Search is rate-limited to 10 searches per second.
        # Update is rate-limited to 45 calls every 60 seconds.
        Start-Sleep -Milliseconds 1334
    }

    Remove-Module -Name ActiveDirectory
    Remove-Module -Name teamdynamix-psclient
} else {
    Write-Verbose -Message "The settings file $SettingsFile does not exist. Run Sample-New-ExcelImportTemplate.ps1 to create the settings file first."
}
