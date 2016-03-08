#
# Sample-New-AdminSession.ps1
#
# Logins with an administrative account, display current user information.
#
# Tested on Windows 10, PowerShell 5.0.10240.16384.
#

$Script:DebugPreference   = 'Continue'
$Script:VerbosePreference = 'Continue'

Import-Module -Name "$PSScriptRoot\..\teamdynamix-psclient"

$UserNameFile = "$PSScriptRoot\..\_secret\credentials-admin.username.txt"
$PasswordFile = "$PSScriptRoot\..\_secret\credentials-admin.password.txt"
$BearerFile   = "$PSScriptRoot\..\_secret\credentials-admin.bearer.txt"

$Bearer = New-TdpscCachedLoginSession -UserNameFile $UserNameFile -PasswordFile $PasswordFile -BearerFile $BearerFile -IsAdminCredential $true

$User = $Bearer | Get-TdpscLoginSession
$User | Select -Property *
if ($User -eq $null) {
    Write-Host 'Need to refresh Bearer token!'
}

Remove-Module -Name teamdynamix-psclient
