#
# Sample-Get-Department.ps1
#
# Gets a list of all active accounts/departments.
#
# Tested on Windows 10, PowerShell 5.0.10240.16384.
#

#Requires -Version 3

Set-StrictMode -Version 3

$Script:DebugPreference   = 'Continue'
$Script:VerbosePreference = 'Continue'

Import-Module -Name "$PSScriptRoot\..\teamdynamix-psclient"

$UserNameFile = "$PSScriptRoot\..\_secret\credentials-user.username.txt"
$PasswordFile = "$PSScriptRoot\..\_secret\credentials-user.password.txt"
$BearerFile   = "$PSScriptRoot\..\_secret\credentials-user.bearer.txt"

Set-TdpscApiBaseAddress -Target 'Sandbox'

$Bearer = New-TdpscCachedLoginSession -UserNameFile $UserNameFile -PasswordFile $PasswordFile -BearerFile $BearerFile

$Accounts = $Bearer | Get-TdpscAccount
$Accounts | Select-Object -Property ID,Name | Sort-Object -Property Name

Remove-Module -Name teamdynamix-psclient
