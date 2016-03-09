#
# Sample-New-PersonImport.ps1
#
# Accepts a file, stores that file on disk, and places an entry into the database to indicate to the import file processor to pick up the file and run a People Import on it.
#
# Run Sample-New-ExcelImportTemplate.ps1 to create settings file first.
#
# Tested on Windows 10, PowerShell 5.0.10240.16384.
#

Set-StrictMode -Version 3

$Script:DebugPreference   = 'Continue'
$Script:VerbosePreference = 'Continue'

Import-Module -Name "$PSScriptRoot\..\teamdynamix-psclient"

$UserNameFile = "$PSScriptRoot\..\_secret\credentials-admin.username.txt"
$PasswordFile = "$PSScriptRoot\..\_secret\credentials-admin.password.txt"
$BearerFile   = "$PSScriptRoot\..\_secret\credentials-admin.bearer.txt"
$SettingsFile = "$PSScriptRoot\..\_secret\Sample-PersonImport.settings.txt"

if ((Test-Path -Path $SettingsFile) -eq $true) {
    $Settings = Get-Content -Path $SettingsFile -Raw | ConvertFrom-Json

    $Bearer = New-TdpscCachedLoginSession -UserNameFile $UserNameFile -PasswordFile $PasswordFile -BearerFile $BearerFile -IsAdminCredential $true

    $ImportStatus = $Bearer | New-TdpscPersonImport -Path $Settings.ExportXLSXPath
    $ImportStatus
} else {
    Write-Verbose -Message "The settings file $SettingsFile does not exist. Run Sample-New-ExcelImportTemplate.ps1 to create the settings file first."
}

Remove-Module -Name teamdynamix-psclient
