#
# Sample-Get-PersonSearch.ps1
#
# Gets a list of users. Does not return collection objects such as Applications, Permissions, Groups, or Custom Attributes. Use the singular GET to retrieve these collections for a singular user.
#
# Tested on Windows 10, PowerShell 5.0.10240.16384.
#

$Script:DebugPreference   = 'Continue'
$Script:VerbosePreference = 'Continue'

Import-Module -Name "$PSScriptRoot\..\teamdynamix-psclient"

$UserNameFile = "$PSScriptRoot\..\_secret\credentials-user.username.txt"
$PasswordFile = "$PSScriptRoot\..\_secret\credentials-user.password.txt"
$BearerFile   = "$PSScriptRoot\..\_secret\credentials-user.bearer.txt"

$Bearer = New-TdpscCachedLoginSession -UserNameFile $UserNameFile -PasswordFile $PasswordFile -BearerFile $BearerFile

$SearchText = Read-Host -Prompt 'Enter the search text to perform LIKE-based filtering on'
$Users = $Bearer | Get-TdpscPersonSearch -SearchText $SearchText
$Users

$SearchText = Read-Host -Prompt 'Enter the search text to perform restricted search'
$Users = $Bearer | Get-TdpscRestrictedPersonSearch -SearchText $SearchText
$Users

Remove-Module -Name teamdynamix-psclient
