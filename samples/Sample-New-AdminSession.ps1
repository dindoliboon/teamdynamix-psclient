#
# Sample-New-AdminSession.ps1
#
# Logins with an administrative account, display current user information.
#
# Tested on Windows 10, PowerShell 5.0.10240.16384.
#

#Requires -Version 3

Set-StrictMode -Version 3

$Script:DebugPreference   = 'Continue'
$Script:VerbosePreference = 'Continue'

Import-Module -Name "$PSScriptRoot\..\teamdynamix-psclient"

$UserNameFile = "$PSScriptRoot\..\_secret\credentials-admin.username.txt"
$PasswordFile = "$PSScriptRoot\..\_secret\credentials-admin.password.txt"
$BearerFile   = "$PSScriptRoot\..\_secret\credentials-admin.bearer.txt"

Set-TdpscApiBaseAddress -Target 'Sandbox'

$Bearer = New-TdpscCachedLoginSession -UserNameFile $UserNameFile -PasswordFile $PasswordFile -BearerFile $BearerFile -IsAdminCredential $true

$User = $Bearer | Get-TdpscLoginSession
$User | Select-Object -Property *
if ($null -eq $User) {
    Write-Error -Message 'Need to refresh Bearer token!'
}

Remove-Module -Name teamdynamix-psclient
