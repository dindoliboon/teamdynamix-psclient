#Requires -Version 3

Set-StrictMode -Version 3

#Continue
#SilentlyContinue
$Script:DebugPreference   = 'SilentlyContinue'
$Script:VerbosePreference = 'SilentlyContinue'

Import-Module -Name "$PSScriptRoot\..\..\..\..\..\teamdynamix-psclient"

InModuleScope teamdynamix-psclient {
    $bearer                 = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1bmlxdWVfbmFtZSI6InVzZXJAbG9jYWwiLCJpc3MiOiJURCIsImF1ZCI6Imh0dHBzOi8vd3d3LnRlYW1keW5hbWl4LmNvbS8iLCJleHAiOjE0NTgwNDg2NTEsIm5iZiI6MTQ1Nzk2MjI1MX0.DYFzy8Q9Nn0sR7fY-28vY8GHhRTn1aFe36BHy9u_J2w'

    <#
        # Generic catch-all. This will throw an exception if we forgot to mock something.
        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient {
            Write-Debug -Message 'Mocked Invoke-WebRequest with no parameter filter.'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"
            Write-Debug -Message "`t[Body]   $Body"

            throw "Unidentified call to Invoke-WebRequest"
        }
    #>

    Describe 'New-TdpscPerson' {
        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Post' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'people') -and $Body -eq '{"Password":"not-very-secure","UserName":"MyUser@example.com","DesktopID":"00000000-0000-0000-0000-000000000000","UID":"00000000-0000-0000-0000-000000000000","BEID":"00000000-0000-0000-0000-000000000000","BEIDInt":0,"IsActive":true,"FullName":"","FirstName":"John","LastName":"Doe","MiddleName":"","Birthday":"\/Date(-62135578800000)\/","Salutation":"","Nickname":"","DefaultAccountID":0,"DefaultAccountName":"","PrimaryEmail":"MyUser@example.com","AlternateEmail":"","ExternalID":"","AlternateID":"","Applications":null,"SecurityRoleName":"","SecurityRoleID":"8ab0f7f5-6e34-4cfa-a75a-ad2a2fc6bc9c","Permissions":null,"OrgApplications":null,"GroupIDs":null,"ReferenceID":0,"AlertEmail":"MyUser@example.com","Company":"Awesome Company","Title":"","HomePhone":"","PrimaryPhone":"","WorkPhone":"","Pager":"","OtherPhone":"","MobilePhone":"","Fax":"","DefaultPriorityID":0,"DefaultPriorityName":"","AboutMe":"","WorkAddress":"","WorkCity":"","WorkState":"","WorkZip":"12345","WorkCountry":"","HomeAddress":"","HomeCity":"","HomeState":"","HomeZip":"","HomeCountry":"","DefaultRate":0,"CostRate":0,"IsEmployee":false,"WorkableHours":0,"IsCapacityManaged":false,"ReportTimeAfterDate":"\/Date(-62135578800000)\/","EndDate":"\/Date(-62135578800000)\/","ShouldReportTime":false,"ReportsToUID":"","ReportsToFullName":"","ResourcePoolID":0,"ResourcePoolName":"","TZID":2,"TZName":"","TypeID":1,"AuthenticationUserName":"MyUser@example.com","AuthenticationProviderID":null,"Attributes":null,"Gender":0,"IMProvider":"","IMHandle":""}'} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"
            Write-Debug -Message "`t[Body]   $Body"

            [PSCustomObject]@{Content = $Body}
        }

        Mock Get-InternalBearer -ModuleName teamdynamix-psclient {
            Write-Debug -Message 'Get-InternalBearer'

            $bearer
        }

        Context 'Examples' {
            It 'Accepts creating new person with parameters' {
                $tmp = New-TdpscPerson -Password 'not-very-secure' -UserName 'MyUser@example.com' -AuthenticationUserName 'MyUser@example.com' -FirstName 'John' -LastName 'Doe' -PrimaryEmail 'MyUser@example.com' -TZID 2 -TypeID 1 -AlertEmail 'MyUser@example.com' -Company 'Awesome Company' -WorkZip '12345' -SecurityRoleID '8ab0f7f5-6e34-4cfa-a75a-ad2a2fc6bc9c'

                $tmp.GetType().FullName | Should -BeIn @('System.Management.Automation.PSCustomObject', 'TeamDynamix.Api.Users.User')
                $tmp.UserName | Should Be 'MyUser@example.com'
            }
        }
    }
}

Remove-Module -Name teamdynamix-psclient
