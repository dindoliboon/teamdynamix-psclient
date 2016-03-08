TeamDynamix PSClient
=============
Unofficial PowerShell module for interacting with [TeamDynamix Web API 9.3](https://app.teamdynamix.com/TDWebApi).

This module is not complete and does not implement the entire TeamDynamix Web API.

Tested on Windows 10, PowerShell 5.0.10240.16384.

Install
=======

```powershell
# Install in your personal modules folder
# (e.g. $env:USERPROFILE\Documents\WindowsPowerShell\Modules\)
# or to a folder of your choice, with:
Invoke-Expression -Command (New-Object System.Net.WebClient).DownloadString('https://raw.github.com/dindoliboon/teamdynamix-psclient/master/Install.ps1')

# Import the module
Import-Module -Name "V:\WindowsPowerShell\Modules\teamdynamix-psclient\teamdynamix-psclient"
```

Examples
=======
See the [samples](https://github.com/dindoliboon/teamdynamix-psclient/tree/master/samples) directory.

### Get list of departments

```powershell
# Open a user session.
$bearer = Get-Credential | New-TdpscLoginSession

# Get list of accounts/departments.
$accounts = $bearer | Get-TdpscAccount

# Display only ID and Name as a table.
$accounts | Select -Property ID,Name | Sort-Object -Property Name
```

### Perform restricted user search
Does not return full user information.

```powershell
# Open a user session.
$bearer = Get-Credential | New-TdpscLoginSession

# Get list of accounts/departments.
$accounts = $bearer | Get-TdpscAccount

# Perform restricted search.
$users = $bearer | Get-TdpscRestrictedPersonSearch -SearchText 'John Doe'

# Display results as a list.
$users
```

### Disable a person
Account performing action must have API user access.

For details about your BEID and web services key, see [How to log into the Web API](https://solutions.teamdynamix.com/TDClient/KB/ArticleDet?ID=1715).

```powershell
# Open an administrative session (uses BEID and web services key).
$bearer = Get-Credential | New-TdpscLoginAdminSession

# Get full details.
# UID was obtained from Get-TdpscRestrictedPersonSearch.
$person = Get-TdpscPerson -Bearer $bearer -UID '9c83c59e-becf-4c12-b8db-09f6c022ef58'

# Disable person.
$person.IsActive = $false

# Apply changes.
$updatedPerson = Set-TdpscPerson -Bearer $bearer -Person $person

# Display results as a list.
$updatedPerson
```

Credits
=======
1. [PSExcel module](https://github.com/RamblingCookieMonster/PSExcel).
Sample-New-ExcelImportTemplate.ps1

2. [Multipart HTTP Post with PowerShell](http://stackoverflow.com/questions/25075010/upload-multiple-files-from-powershell-script/34771519)
people.ps1

3. [PowerShell module installer](https://github.com/lzybkr/TabExpansionPlusPlus) Install.ps1
