#
# Sample-New-ExcelImportTemplate.ps1
#
# Generates the XLSX file used by TeamDynmaix.
#
# Requires PowerShell module PsExcel, https://github.com/RamblingCookieMonster/PSExcel
# Module will be installed to: $home\Documents\WindowsPowerShell\Modules
#     Install-Module -Name PSExcel -Scope CurrentUser
#
# Tested on Windows 10, PowerShell 5.0.10240.16384.
#

$Script:DebugPreference   = 'Continue'
$Script:VerbosePreference = 'SilentlyContinue'

$SettingsFile = "$PSScriptRoot\..\_secret\Sample-PersonImport.settings.txt"

if ((Test-Path -Path $SettingsFile) -eq $true) {
    $Settings = Get-Content -Path $SettingsFile | ConvertFrom-Json

    Import-Module -Name ActiveDirectory
    Import-Module -Name $Settings.PsExcelModulePath

    $employeesAd = Get-ADUser -LDAPFilter $Settings.LDAPFilter -SearchBase $Settings.SearchBase -SearchScope Subtree -Properties sAMAccountName,givenName,sn,company,department,mail,telephoneNumber,title,physicalDeliveryOfficeName,manager

    $employeesAd | Select @{label = 'User Type'; Expression = {'customer';}},
                        @{label = 'Username'; Expression = {$_.sAMAccountName;}},
                        @{label = 'Password'; Expression = {[Guid]::NewGuid().Guid;}},
                        @{label = 'Authentication Provider'; Expression = {'TeamDynamix';}},
                        @{label = 'Authentication Username'; Expression = {$_.sAMAccountName;}},
                        @{label = 'Security Role'; Expression = {'';}},
                        @{label = 'First Name'; Expression = {$_.givenName;}},
                        @{label = 'Last Name'; Expression = {$_.sn;}},
                        @{label = 'Middle Name'; Expression = {'';}},
                        @{label = 'Nickname'; Expression = {'';}},
                        @{label = 'Salutation'; Expression = {'';}},
                        @{label = 'Organization'; Expression = {$_.company;}},
                        @{label = 'Title'; Expression = {$_.title;}},
                        @{label = 'Acct/Dept'; Expression = {$_.department;}},
                        @{label = 'Request Priority'; Expression = {'';}},
                        @{label = 'Birthdate'; Expression = {'';}},
                        @{label = 'Gender'; Expression = {'';}},
                        @{label = 'Organizational ID'; Expression = {'';}},
                        @{label = 'Alternate ID'; Expression = {'';}},
                        @{label = 'Is Employee'; Expression = {'';}},
                        @{label = 'Primary Email'; Expression = {$_.mail;}},
                        @{label = 'Alert Email'; Expression = {$_.mail;}},
                        @{label = 'Alternate Email'; Expression = {'';}},
                        @{label = 'IM Provider'; Expression = {'';}},
                        @{label = 'IM Handle'; Expression = {'';}},
                        @{label = 'Work Phone'; Expression = {$_.telephoneNumber;}},
                        @{label = 'Mobile Phone'; Expression = {'';}},
                        @{label = 'Home Phone'; Expression = {'';}},
                        @{label = 'Pager'; Expression = {'';}},
                        @{label = 'Fax'; Expression = {'';}},
                        @{label = 'Other Phone'; Expression = {'';}},
                        @{label = 'Phone Preference'; Expression = {'Work';}},
                        @{label = 'Work Address'; Expression = {$_.physicalDeliveryOfficeName;}},
                        @{label = 'Work City'; Expression = {'Durham';}},
                        @{label = 'Work State'; Expression = {'NC';}},
                        @{label = 'Work Postal Code'; Expression = {'27707';}},
                        @{label = 'Work Country'; Expression = {'USA';}},
                        @{label = 'Home Address'; Expression = {'';}},
                        @{label = 'Home City'; Expression = {'';}},
                        @{label = 'Home State'; Expression = {'';}},
                        @{label = 'Home Postal Code'; Expression = {'';}},
                        @{label = 'Home Country'; Expression = {'';}},
                        @{label = 'Time Zone ID'; Expression = {'2';}},
                        @{label = 'Capacity Is Managed'; Expression = {'';}},
                        @{label = 'Workable Hours'; Expression = {'';}},
                        @{label = 'Bill Rate'; Expression = {'';}},
                        @{label = 'Cost Rate'; Expression = {'';}},
                        @{label = 'Should Report Time'; Expression = {'';}},
                        @{label = 'Capacity Start Date'; Expression = {'';}},
                        @{label = 'Capacity End Date'; Expression = {'';}},
                        @{label = 'Resource Pool'; Expression = {'';}},
                        @{label = 'Reports To Username'; Expression = { if ($_.manager.Length -gt 0) { (Get-ADUser -Identity $_.manager -Properties mail).mail } else { '' } }},
                        @{label = 'Default TDNext Desktop'; Expression = {'';}},
                        @{label = 'Default TDClient Desktop'; Expression = {'';}},
                        @{label = 'HasTDNext'; Expression = {'';}},
                        @{label = 'HasMyWork'; Expression = {'';}},
                        @{label = 'HasTDAnalysis'; Expression = {'';}},
                        @{label = 'HasTDCommunity'; Expression = {'';}},
                        @{label = 'HasTDCRM'; Expression = {'';}},
                        @{label = 'HasTDFileCabinet'; Expression = {'';}},
                        @{label = 'HasTDFinance'; Expression = {'';}},
                        @{label = 'HasTDQuestions'; Expression = {'';}},
                        @{label = 'HasTDKnowledgeBase'; Expression = {'';}},
                        @{label = 'HasTDNews'; Expression = {'';}},
                        @{label = 'HasTDPortfolios'; Expression = {'';}},
                        @{label = 'HasTDPP'; Expression = {'';}},
                        @{label = 'HasTDProjectRequest'; Expression = {'';}},
                        @{label = 'HasTDProjects'; Expression = {'';}},
                        @{label = 'HasTDRequests'; Expression = {'';}},
                        @{label = 'HasTDResourceManagement'; Expression = {'';}},
                        @{label = 'HasTDTemplate'; Expression = {'';}},
                        @{label = 'HasTDTicketRequests'; Expression = {'';}},
                        @{label = 'HasTDTimeExpense'; Expression = {'';}},
                        @{label = 'HasTDAssets'; Expression = {'';}},
                        @{label = 'HasTDPeople'; Expression = {'';}},
                        @{label = 'HasTDChat'; Expression = {'';}},
                        @{label = 'HasTDWorkspaces'; Expression = {'';}
        } | Export-XLSX -Path $Settings.ExportXLSXPath -Force

    Remove-Module -Name ActiveDirectory
    Remove-Module -Name PSExcel
} else {
    $Settings = @{
        'PsExcelModulePath' = Read-Host -Prompt 'Enter the complete path to PSExcel, example: V:\WindowsPowerShell\Modules\PSExcel\1.0\PSExcel.psm1'
        'LDAPFilter'        = Read-Host -Prompt 'Enter the LDAP search filter, example: (&(objectCategory=person)(objectClass=user)(mail=*))'
        'SearchBase'        = Read-Host -Prompt 'Enter the LDAP search base, example: OU=Faculty and Staff,OU=SCHOOL,DC=AD,DC=SCHOOL,DC=EDU'
        'ExportXLSXPath'    = "$PSScriptRoot\..\_secret\FacStaffPeopleApiImport.xlsx"
    }

    $Settings | ConvertTo-Json | Set-Content -Path $SettingsFile

    Write-Host -Object 'Settings file has been created, re-run this script now.'
}
