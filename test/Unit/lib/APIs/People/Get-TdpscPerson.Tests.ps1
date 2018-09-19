#Requires -Version 3

Set-StrictMode -Version 3

#Continue
#SilentlyContinue
$Script:DebugPreference   = 'SilentlyContinue'
$Script:VerbosePreference = 'SilentlyContinue'

Import-Module -Name "$PSScriptRoot\..\..\..\..\..\teamdynamix-psclient"

InModuleScope teamdynamix-psclient {
    $bearer                 = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1bmlxdWVfbmFtZSI6InVzZXJAbG9jYWwiLCJpc3MiOiJURCIsImF1ZCI6Imh0dHBzOi8vd3d3LnRlYW1keW5hbWl4LmNvbS8iLCJleHAiOjE0NTgwNDg2NTEsIm5iZiI6MTQ1Nzk2MjI1MX0.DYFzy8Q9Nn0sR7fY-28vY8GHhRTn1aFe36BHy9u_J2w'
    $restGetPerson          = '{"UID":"313f362a-b885-4ea9-996a-6cc9c9eb039b","BEID":"f23d3f8a-a752-4468-8fe2-dedb60a370b7","BEIDInt":190,"IsActive":true,"FullName":"API User","FirstName":"API","LastName":"User","MiddleName":"","Birthday":"0001-01-01T05:00:00Z","Salutation":"","Nickname":"","DefaultAccountID":0,"DefaultAccountName":"None","PrimaryEmail":"","AlternateEmail":"","ExternalID":"","AlternateID":"","Applications":["TDAdmin"],"SecurityRoleName":"","SecurityRoleID":"","Permissions":[],"OrgApplications":[],"GroupIDs":[],"ReferenceID":1000000,"AlertEmail":"","Company":"","Title":"","HomePhone":"","PrimaryPhone":"","WorkPhone":"","Pager":"","OtherPhone":"","MobilePhone":"","Fax":"","DefaultPriorityID":0,"DefaultPriorityName":"None","AboutMe":null,"WorkAddress":"","WorkCity":"","WorkState":"","WorkZip":"","WorkCountry":"","HomeAddress":"","HomeCity":"","HomeState":"","HomeZip":"","HomeCountry":"","DefaultRate":0.0,"CostRate":0.0,"IsEmployee":true,"WorkableHours":8.0,"IsCapacityManaged":false,"ReportTimeAfterDate":"0001-01-01T00:00:00Z","EndDate":"0001-01-01T00:00:00Z","ShouldReportTime":false,"ReportsToUID":"","ReportsToFullName":"","ResourcePoolID":-1,"ResourcePoolName":"","TZID":2,"TZName":"(GMT-05:00)Eastern Time(US and Canada)","TypeID":3,"AuthenticationUserName":"","AuthenticationProviderID":0,"Attributes":[],"Gender":0,"IMProvider":"","IMHandle":""}'

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

    Describe 'Get-TdpscPerson' {
        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Get' -and $URI -eq ((Get-TdpscApiBaseAddress) + "people/$($UID)")} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"
            Write-Debug -Message "`t[UID]    $UID"

            [PSCustomObject]@{Content = $restGetPerson}
        }

        Context 'Passing with parameter' {
            It 'Accepts -Bearer and -UID' {
                $UID = '313f362a-b885-4ea9-996a-6cc9c9eb039b'

                $tmp = Get-TdpscPerson -Bearer $bearer -UID $UID

                $tmp.UID | Should Be $UID
                $tmp.GetType().FullName | Should -BeIn @('System.Management.Automation.PSCustomObject', 'TeamDynamix.Api.Users.User')
            }
        }

        Context 'Passing bearer from pipeline' {
            It 'Accepts -UID' {
                $UID = '313f362a-b885-4ea9-996a-6cc9c9eb039b'

                ($bearer | Get-TdpscPerson -UID $UID).UID | Should Be $UID
            }
        }

        Context 'Passing without parameter name' {
            It 'Accepts Bearer and -UID' {
                $UID = '313f362a-b885-4ea9-996a-6cc9c9eb039b'

                (Get-TdpscPerson $bearer -UID $UID).UID | Should Be $UID
            }

            It 'Accepts with Bearer and UID (Fails in 1.0.0.5 and earlier)' {
                $UID = '313f362a-b885-4ea9-996a-6cc9c9eb039b'

                (Get-TdpscPerson $bearer $UID).UID | Should Be $UID
            }
        }

    }
}

Remove-Module -Name teamdynamix-psclient
