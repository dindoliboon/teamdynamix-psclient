#### :warning: This repository has been archived.

---

TeamDynamix PSClient
=============
Unofficial PowerShell module for interacting with [TeamDynamix Web API 9.3](https://app.teamdynamix.com/TDWebApi).

This module is not complete and does not implement the entire TeamDynamix Web API.

Tested on Windows 10, PowerShell 5.0.10240.16384 and Windows Server 2012 R2, PowerShell 4.0.

Install
=======

```powershell
# Install in your personal modules folder
# (e.g. $env:USERPROFILE\Documents\WindowsPowerShell\Modules\)
# or to a folder of your choice, with:
Invoke-Expression -Command (New-Object System.Net.WebClient).DownloadString('https://raw.github.com/dindoliboon/teamdynamix-psclient/master/Install.ps1')

# Import the module
Import-Module -Name "V:\scripts\teamdynamix-psclient\1.0.0.6\teamdynamix-psclient"
```

Examples
=======
See the [samples](https://github.com/dindoliboon/teamdynamix-psclient/tree/master/samples) directory.

### Get list of departments

```powershell
# Open a user session.
$bearer = Get-Credential | New-TdpscLoginSession

# Get list of accounts/departments.
Get-TdpscAccount | Select -Property ID, Name
```

### Perform restricted user search
Does not return full user information.

```powershell
# Open a user session.
$bearer = Get-Credential | New-TdpscLoginSession

# Perform restricted search.
Get-TdpscRestrictedPersonSearch -SearchText 'John Doe'
```

### Disable a person
Account performing action must have API user access. For details about your BEID and web services key, see [How to log into the Web API](https://solutions.teamdynamix.com/TDClient/KB/ArticleDet?ID=1715).

```powershell
# Open an administrative session (uses BEID and web services key).
$bearer = Get-Credential | New-TdpscLoginAdminSession

# Pass full person details via pipeline, disable person.
# UID was obtained from Get-TdpscRestrictedPersonSearch.
Get-TdpscPerson -UID '9c83c59e-becf-4c12-b8db-09f6c022ef58' | Set-TdpscPerson -IsActive $false
```

### Import users from XLSX
TeamDynamix processes People imports at 3 AM EST. See [How to use the TDWebApi Import service to sync users between your organization and TeamDynamix](https://solutions.teamdynamix.com/TDClient/KB/ArticleDet?ID=4191).

Account performing action must have API user access. For details about your BEID and web services key, see [How to log into the Web API](https://solutions.teamdynamix.com/TDClient/KB/ArticleDet?ID=1715).

Active Directory Cmdlets will need to be installed (included in [RSAT](https://www.microsoft.com/en-us/download/details.aspx?id=45520)).

1. Download PSExcel from
   https://github.com/RamblingCookieMonster/PSExcel/archive/master.zip

2. Extract \PSExcel-master\PSExcel\ in master.zip to V:\scripts\PSExcel\1.0\

3. Open PowerShell console.

4. Run PowerShell command below.
   ```powershell
   Invoke-Expression -Command (New-Object System.Net.WebClient).DownloadString('https://raw.github.com/dindoliboon/teamdynamix-psclient/master/Install.ps1')
   ```

5. For the teamdynamix-psclient install path, enter:
   > V:\scripts\teamdynamix-psclient

6. Create the settings file by running the PowerShell command below.
   ```powershell
   & 'V:\scripts\teamdynamix-psclient\1.0.0.6\samples\Sample-New-ExcelImportTemplate.ps1'
   ```

7. For PSExcel path, enter:
   > V:\scripts\PSExcel\1.0\PSExcel.psm1

8. For LDAP search filter (this includes enabled accounts, with mail attribute, for person/user objects, and member of faculty or staff), enter:
   > (&(!(userAccountControl:1.2.840.113556.1.4.803:=2))(objectCategory=person)(objectClass=user)(mail=\*)(sAMAccountName=\*)(|(memberOf=CN=Faculty,OU=Groups,OU=SCHOOL,DC=AD,DC=SCHOOL,DC=EDU)(memberOf=CN=Staff,OU=Groups,OU=SCHOOL,DC=AD,DC=SCHOOL,DC=EDU)))

9. For LDAP search base, enter:
   > OU=Faculty and Staff,OU=SCHOOL,DC=AD,DC=SCHOOL,DC=EDU

10. Create the XLSX by running the PowerShell command below. This process can take a few minutes depending on the size of your search base.
    ```powershell
    & 'V:\scripts\teamdynamix-psclient\1.0.0.6\samples\Sample-New-ExcelImportTemplate.ps1'
    ```

11. Upload the XLSX to TeamDynamix by running the PowerShell command below. This will also prompt for your administrative credentials for the first time and save it to a file.
    ```powershell
    & 'V:\scripts\teamdynamix-psclient\1.0.0.6\samples\Sample-New-PersonImport.ps1'
    ```

To-do
=======
* ~~Complete first section for API (Accounts, Attachments, Attributes, Auth, Groups, Locations, People).~~
* ~~Created initial module, which uses Json.NET and TeamDynamix.Api.dll to deserialize data to/from API calls into correct data types.~~

Credits
=======
1. [PSExcel module](https://github.com/RamblingCookieMonster/PSExcel)
Sample-New-ExcelImportTemplate.ps1

2. [Multipart HTTP Post with PowerShell](http://stackoverflow.com/questions/25075010/upload-multiple-files-from-powershell-script/34771519)
people.ps1

3. [PowerShell module installer](https://github.com/lzybkr/TabExpansionPlusPlus) Install.ps1

4. [PSJira](https://github.com/replicaJunction/PSJira) and [PowerShell module for Ravello Systems](https://github.com/lucdekens/Ravello) with Pester and module design.

5. [Decode JwtToken](https://gallery.technet.microsoft.com/JWT-Token-Decode-637cf001) Decode-JwtToken.internal.ps1
