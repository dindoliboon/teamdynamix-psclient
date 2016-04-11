#
# Sample-Set-Person.ps1
#
# Changes the department for a specified user.
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

$UID = Read-Host -Prompt 'Enter the UID of the person to update'
$Person = Get-TdpscPerson -Bearer $Bearer -UID $UID

if ($null -ne $Person) {
    $Departments = $Bearer | Get-TdpscAccount

    Write-Host -Object 'Before update, you are a member of the following department:'
    $Departments | Where-Object { $_.ID -like $Person.DefaultAccountID } | Select-Object -Property ID,Name

    Write-Host -Object 'List of departments:'
    $Departments | Select-Object -Property ID,Name | Sort-Object -Property Name | Format-Table

    # Department is set based off account ID.
    $DefaultAccountID = Read-Host -Prompt 'Enter the new department ID'
    $NewPersonValue = $Person
    $NewPersonValue.DefaultAccountID = $DefaultAccountID
    $UpdatedPerson = Set-TdpscPerson -Bearer $Bearer -Person $NewPersonValue

    Write-Host -Object 'After update, you are a member of the following department:'
    $Departments | Where-Object { $_.ID -like $UpdatedPerson.DefaultAccountID } | Select-Object -Property ID,Name
}

Remove-Module -Name teamdynamix-psclient
