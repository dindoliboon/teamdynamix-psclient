#
# Sample-Set-Person.ps1
#
# Changes the department for a specified user.
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

$UID = Read-Host -Prompt 'Enter the UID of the person to update'
$Person = Get-TdpscPerson -Bearer $Bearer -UID $UID

if ($Person -ne $null) {
    $Departments = $Bearer | Get-TdpscAccount

    Write-Debug -Message 'Before update, you are a member of the following department:'
    $Departments |? { $_.ID -like $Person.DefaultAccountID } | Select -Property ID,Name

    Write-Debug -Message 'List of departments:'
    $Departments | Select -Property ID,Name | Sort-Object -Property Name | Format-Table

    # Department is set based off account ID.
    $DefaultAccountID = Read-Host -Prompt 'Enter the new department ID'
    $NewPersonValue = $Person
    $NewPersonValue.DefaultAccountID = $DefaultAccountID
    $UpdatedPerson = Set-TdpscPerson -Bearer $Bearer -Person $NewPersonValue

    Write-Debug -Message 'After update, you are a member of the following department:'
    $Departments |? { $_.ID -like $UpdatedPerson.DefaultAccountID } | Select -Property ID,Name
}

Remove-Module -Name teamdynamix-psclient
