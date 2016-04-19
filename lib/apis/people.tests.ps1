#Requires -Version 3

Set-StrictMode -Version 3

#Continue
#SilentlyContinue
$Script:DebugPreference   = 'SilentlyContinue'
$Script:VerbosePreference = 'SilentlyContinue'

Import-Module -Name "$PSScriptRoot\..\..\teamdynamix-psclient"

InModuleScope teamdynamix-psclient {
    $bearer                 = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1bmlxdWVfbmFtZSI6InVzZXJAbG9jYWwiLCJpc3MiOiJURCIsImF1ZCI6Imh0dHBzOi8vd3d3LnRlYW1keW5hbWl4LmNvbS8iLCJleHAiOjE0NTgwNDg2NTEsIm5iZiI6MTQ1Nzk2MjI1MX0.DYFzy8Q9Nn0sR7fY-28vY8GHhRTn1aFe36BHy9u_J2w'
    $restPeopleSearch       = '[{"UID":"313f362a-b885-4ea9-996a-6cc9c9eb039b","BEID":"f23d3f8a-a752-4468-8fe2-dedb60a370b7","BEIDInt":190,"IsActive":true,"FullName":"API User","FirstName":"API","LastName":"User","MiddleName":"","Birthday":"0001-01-01T05:00:00Z","Salutation":"","Nickname":"","DefaultAccountID":0,"DefaultAccountName":"None","PrimaryEmail":"","AlternateEmail":"","ExternalID":"","AlternateID":"","Applications":["TDAdmin"],"SecurityRoleName":"","SecurityRoleID":"","Permissions":[],"OrgApplications":[],"GroupIDs":[],"ReferenceID":1000000,"AlertEmail":"","Company":"","Title":"","HomePhone":"","PrimaryPhone":"","WorkPhone":"","Pager":"","OtherPhone":"","MobilePhone":"","Fax":"","DefaultPriorityID":0,"DefaultPriorityName":"None","AboutMe":null,"WorkAddress":"","WorkCity":"","WorkState":"","WorkZip":"","WorkCountry":"","HomeAddress":"","HomeCity":"","HomeState":"","HomeZip":"","HomeCountry":"","DefaultRate":0.0,"CostRate":0.0,"IsEmployee":true,"WorkableHours":8.0,"IsCapacityManaged":false,"ReportTimeAfterDate":"0001-01-01T00:00:00Z","EndDate":"0001-01-01T00:00:00Z","ShouldReportTime":false,"ReportsToUID":"","ReportsToFullName":"","ResourcePoolID":-1,"ResourcePoolName":"","TZID":2,"TZName":"(GMT-05:00)Eastern Time(US and Canada)","TypeID":3,"AuthenticationUserName":"","AuthenticationProviderID":0,"Attributes":[],"Gender":0,"IMProvider":"","IMHandle":""},{"UID":"313f362a-b885-4ea9-996a-6cc9c9eb0391","BEID":"f23d3f8a-a752-4468-8fe2-dedb60a370b1","BEIDInt":191,"IsActive":true,"FullName":"API User 2","FirstName":"API","LastName":"User 2","MiddleName":"","Birthday":"0001-01-01T05:00:00Z","Salutation":"","Nickname":"","DefaultAccountID":0,"DefaultAccountName":"None","PrimaryEmail":"","AlternateEmail":"","ExternalID":"","AlternateID":"","Applications":["TDAdmin"],"SecurityRoleName":"","SecurityRoleID":"","Permissions":[],"OrgApplications":[],"GroupIDs":[],"ReferenceID":1000001,"AlertEmail":"","Company":"","Title":"","HomePhone":"","PrimaryPhone":"","WorkPhone":"","Pager":"","OtherPhone":"","MobilePhone":"","Fax":"","DefaultPriorityID":0,"DefaultPriorityName":"None","AboutMe":null,"WorkAddress":"","WorkCity":"","WorkState":"","WorkZip":"","WorkCountry":"","HomeAddress":"","HomeCity":"","HomeState":"","HomeZip":"","HomeCountry":"","DefaultRate":0.0,"CostRate":0.0,"IsEmployee":true,"WorkableHours":8.0,"IsCapacityManaged":false,"ReportTimeAfterDate":"0001-01-01T00:00:00Z","EndDate":"0001-01-01T00:00:00Z","ShouldReportTime":false,"ReportsToUID":"","ReportsToFullName":"","ResourcePoolID":-1,"ResourcePoolName":"","TZID":2,"TZName":"(GMT-05:00)Eastern Time(US and Canada)","TypeID":3,"AuthenticationUserName":"","AuthenticationProviderID":0,"Attributes":[],"Gender":0,"IMProvider":"","IMHandle":""}]'
    $restGetPerson          = '{"UID":"313f362a-b885-4ea9-996a-6cc9c9eb039b","BEID":"f23d3f8a-a752-4468-8fe2-dedb60a370b7","BEIDInt":190,"IsActive":true,"FullName":"API User","FirstName":"API","LastName":"User","MiddleName":"","Birthday":"0001-01-01T05:00:00Z","Salutation":"","Nickname":"","DefaultAccountID":0,"DefaultAccountName":"None","PrimaryEmail":"","AlternateEmail":"","ExternalID":"","AlternateID":"","Applications":["TDAdmin"],"SecurityRoleName":"","SecurityRoleID":"","Permissions":[],"OrgApplications":[],"GroupIDs":[],"ReferenceID":1000000,"AlertEmail":"","Company":"","Title":"","HomePhone":"","PrimaryPhone":"","WorkPhone":"","Pager":"","OtherPhone":"","MobilePhone":"","Fax":"","DefaultPriorityID":0,"DefaultPriorityName":"None","AboutMe":null,"WorkAddress":"","WorkCity":"","WorkState":"","WorkZip":"","WorkCountry":"","HomeAddress":"","HomeCity":"","HomeState":"","HomeZip":"","HomeCountry":"","DefaultRate":0.0,"CostRate":0.0,"IsEmployee":true,"WorkableHours":8.0,"IsCapacityManaged":false,"ReportTimeAfterDate":"0001-01-01T00:00:00Z","EndDate":"0001-01-01T00:00:00Z","ShouldReportTime":false,"ReportsToUID":"","ReportsToFullName":"","ResourcePoolID":-1,"ResourcePoolName":"","TZID":2,"TZName":"(GMT-05:00)Eastern Time(US and Canada)","TypeID":3,"AuthenticationUserName":"","AuthenticationProviderID":0,"Attributes":[],"Gender":0,"IMProvider":"","IMHandle":""}'
    $newPersonJson          = '{"UID":"","BEID":"","BEIDInt":0,"IsActive":true,"FullName":"","FirstName":"","LastName":"","MiddleName":"","Birthday":"","Salutation":"","Nickname":"","DefaultAccountID":0,"DefaultAccountName":"","PrimaryEmail":"","AlternateEmail":"","ExternalID":"","AlternateID":"","Applications":[],"SecurityRoleName":"","SecurityRoleID":"","Permissions":[],"OrgApplications":[],"GroupIDs":[],"ReferenceID":0,"AlertEmail":"","Company":"","Title":"","HomePhone":"","PrimaryPhone":"","WorkPhone":"","Pager":"","OtherPhone":"","MobilePhone":"","Fax":"","DefaultPriorityID":0,"DefaultPriorityName":"None","AboutMe":null,"WorkAddress":"","WorkCity":"","WorkState":"","WorkZip":"","WorkCountry":"","HomeAddress":"","HomeCity":"","HomeState":"","HomeZip":"","HomeCountry":"","DefaultRate":0.0,"CostRate":0.0,"IsEmployee":true,"WorkableHours":8.0,"IsCapacityManaged":false,"ReportTimeAfterDate":"0001-01-01T00:00:00Z","EndDate":"0001-01-01T00:00:00Z","ShouldReportTime":false,"ReportsToUID":"","ReportsToFullName":"","ResourcePoolID":-1,"ResourcePoolName":"","TZID":2,"TZName":"(GMT-05:00)Eastern Time(US and Canada)","TypeID":3,"AuthenticationUserName":"","AuthenticationProviderID":0,"Attributes":[],"Gender":0,"IMProvider":"","IMHandle":""}'
    $functionalRole1        = '{"ID":1,"FunctionalRoleID":6565,"UID":"54bf5ef9-7b30-45fb-a4f9-73483a93d899","FunctionalRoleName":null,"StandardRate":0.0,"CostRate":0.0,"CreatedDate":"2016-02-15T20:48:36.737Z","Comments":null,"IsPrimary":false}'
    $functionalRole2        = '{"ID":2,"FunctionalRoleID":6594,"UID":"5bef4f9d-321e-48a7-b0d7-c9c2f31aaf6e","FunctionalRoleName":null,"StandardRate":0.0,"CostRate":0.0,"CreatedDate":"2016-02-18T15:33:39.53Z","Comments":"","IsPrimary":false}'
    $restGetFunctionalRoles = "[$functionalRole1,$functionalRole2]"
    $group1                 = '{"ID":1,"FunctionalRoleID":1,"UID":"14c88477-25d4-e511-b52c-000d3a113111","FunctionalRoleName":null,"StandardRate":0.0,"CostRate":100.0,"CreatedDate":"2016-02-15T20:48:36.737Z","Comments":null,"IsPrimary":false}'
    $group2                 = '{"ID":2,"FunctionalRoleID":2,"UID":"14c88477-25d4-e511-b52c-000d3a113222","FunctionalRoleName":null,"StandardRate":0.0,"CostRate":200.0,"CreatedDate":"2016-02-18T15:33:39.53Z","Comments":"","IsPrimary":false}'
    $restGetGroups          = "[$group1,$group2]"
    $searchText             = 'John Doe'
    $maxResults             = 25

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
                $tmp.GetType().FullName | Should Be 'System.Management.Automation.PSCustomObject', 'TeamDynamix.Api.Users.User'
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

    Describe 'Get-TdpscPersonFunctionalRole' {
        Mock Get-InternalBearer -ModuleName teamdynamix-psclient {
            Write-Debug -Message 'Get-InternalBearer'

            $bearer
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Get' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'people/313f362a-b885-4ea9-996a-6cc9c9eb039b/functionalroles')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"
            Write-Debug -Message "`t[Body]   $Body"

            [PSCustomObject]@{Content = $restGetFunctionalRoles}
        }

        Context 'Examples' {
            It 'Accepts getting roles by -UID' {
                $tmp = Get-TdpscPersonFunctionalRole -UID '313f362a-b885-4ea9-996a-6cc9c9eb039b'

                $tmp.GetType().FullName | Should Be 'System.Object[]'
                $tmp[0].GetType().FullName | Should Be 'System.Management.Automation.PSCustomObject', 'TeamDynamix.Api.Roles.UserFunctionalRole'
                $tmp.Count | Should Be 2
            }

            It 'Accepts getting roles by pipeline' {
                $tmp = '313f362a-b885-4ea9-996a-6cc9c9eb039b' | Get-TdpscPersonFunctionalRole

                $tmp.GetType().FullName | Should Be 'System.Object[]'
                $tmp[0].GetType().FullName | Should Be 'System.Management.Automation.PSCustomObject', 'TeamDynamix.Api.Roles.UserFunctionalRole'
                $tmp.Count | Should Be 2
            }
        }
    }

    Describe 'Get-TdpscPersonGroup' {
        Mock Get-InternalBearer -ModuleName teamdynamix-psclient {
            Write-Debug -Message 'Get-InternalBearer'

            $bearer
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Get' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'people/313f362a-b885-4ea9-996a-6cc9c9eb039b/groups')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"
            Write-Debug -Message "`t[Body]   $Body"

            [PSCustomObject]@{Content = $restGetGroups}
        }

        Context 'Examples' {
            It 'Accepts getting groups by -UID' {
                $tmp = Get-TdpscPersonGroup -UID '313f362a-b885-4ea9-996a-6cc9c9eb039b'

                $tmp.GetType().FullName | Should Be 'System.Object[]'
                $tmp[0].GetType().FullName | Should Be 'System.Management.Automation.PSCustomObject', 'TeamDynamix.Api.Users.UserGroup'
                $tmp.Count | Should Be 2
            }

            It 'Accepts getting groups by pipeline' {
                $tmp = '313f362a-b885-4ea9-996a-6cc9c9eb039b' | Get-TdpscPersonGroup

                $tmp.GetType().FullName | Should Be 'System.Object[]'
                $tmp[0].GetType().FullName | Should Be 'System.Management.Automation.PSCustomObject', 'TeamDynamix.Api.Users.UserGroup'
                $tmp.Count | Should Be 2
                $tmp[0].CostRate | Should Be 100
                $tmp[1].CostRate | Should Be 200
            }
        }
    }

    Describe 'Get-TdpscPersonSearch' {
        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Post' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'people/search')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{Content = $restPeopleSearch}
        }

        Context 'Passing with parameter' {
            It 'Accepts Bearer and SearchText' {
                (Get-TdpscPersonSearch -Bearer $bearer -SearchText $searchText).Count | Should BeGreaterThan 0
            }

            It 'Accepts Bearer, SearchText, and MaxResults' {
                $maxResults = 75
                (Get-TdpscPersonSearch -Bearer $bearer -SearchText $searchText -MaxResults $maxResults).Count | Should BeGreaterThan 0
            }
        }

        Context 'Passing without parameter name' {
            It 'Accepts Bearer' {
                (Get-TdpscPersonSearch $bearer).Count | Should BeGreaterThan 0
            }

            It 'Accepts with Bearer and SearchText (Fails in 1.0.0.5 and earlier)' {
                (Get-TdpscPersonSearch $bearer $searchText).Count | Should BeGreaterThan 0
            }

            It 'Accepts Bearer and -SearchText' {
                (Get-TdpscPersonSearch $bearer -SearchText $searchText).Count | Should BeGreaterThan 0
            }

            It 'Accepts Bearer, -SearchText, and -MaxResults' {
                $maxResults = 75
                (Get-TdpscPersonSearch $bearer -SearchText $searchText -MaxResults $maxResults).Count | Should BeGreaterThan 0
            }

            It 'Accepts with Bearer, SearchText, and -MaxResults (Fails in 1.0.0.5 and earlier)' {
                (Get-TdpscPersonSearch $bearer $searchText -MaxResults 75).Count | Should BeGreaterThan 0
            }

            It 'Accepts with -Bearer, SearchText, and -MaxResults (Fails in 1.0.0.5 and earlier)' {
                (Get-TdpscPersonSearch -Bearer $bearer $searchText -MaxResults 75).Count | Should BeGreaterThan 0
            }
        }

        Context 'Return type check' {
            It 'Accepts -Bearer, returns type Object[]' {
                (Get-TdpscPersonSearch -Bearer $bearer).GetType().FullName | Should Be 'System.Object[]'

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
            }

            It 'Accepts -Bearer, first object returns type PSCustomObject' {
                (Get-TdpscPersonSearch -Bearer $bearer)[0].GetType().FullName | Should Be 'System.Management.Automation.PSCustomObject', 'TeamDynamix.Api.Users.User'

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
            }
        }
    }

    Describe 'Get-TdpscRestrictedPersonSearch' {
        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Get' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'people/lookup?maxResults=50&searchText=John Doe')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{Content = $restPeopleSearch}
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Get' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'people/lookup?maxResults=75&searchText=John Doe')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{Content = $restPeopleSearch}
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Get' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'people/lookup?maxResults=50')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{Content = $restPeopleSearch}
        }

        Context 'Passing with parameter' {
            It 'Accepts Bearer and SearchText' {
                (Get-TdpscRestrictedPersonSearch -Bearer $bearer -SearchText $searchText).Count | Should BeGreaterThan 0
            }

            It 'Accepts Bearer, SearchText, and MaxResults' {
                $maxResults = 75
                (Get-TdpscRestrictedPersonSearch -Bearer $bearer -SearchText $searchText -MaxResults $maxResults).Count | Should BeGreaterThan 0
            }
        }

        Context 'Passing without parameter name' {
            It 'Accepts Bearer' {
                (Get-TdpscRestrictedPersonSearch $bearer).Count | Should BeGreaterThan 0
            }

            It 'Accepts with Bearer and SearchText (Fails in 1.0.0.5 and earlier)' {
                (Get-TdpscRestrictedPersonSearch $bearer $searchText).Count | Should BeGreaterThan 0
            }

            It 'Accepts with Bearer, SearchText, and MaxResults (Fails in 1.0.0.5 and earlier)' {
                (Get-TdpscRestrictedPersonSearch $bearer $searchText 75).Count | Should BeGreaterThan 0
            }

            It 'Accepts Bearer and -SearchText' {
                (Get-TdpscRestrictedPersonSearch $bearer -SearchText $searchText).Count | Should BeGreaterThan 0
            }

            It 'Accepts Bearer, -SearchText, and -MaxResults' {
                $maxResults = 75
                (Get-TdpscRestrictedPersonSearch $bearer -SearchText $searchText -MaxResults $maxResults).Count | Should BeGreaterThan 0
            }

            It 'Accepts with Bearer, SearchText, and -MaxResults (Fails in 1.0.0.5 and earlier)' {
                (Get-TdpscRestrictedPersonSearch $bearer $searchText -MaxResults 75).Count | Should BeGreaterThan 0
            }

            It 'Accepts with -Bearer, SearchText, and -MaxResults (Fails in 1.0.0.5 and earlier)' {
                (Get-TdpscRestrictedPersonSearch -Bearer $bearer $searchText -MaxResults 75).Count | Should BeGreaterThan 0
            }
        }

        Context 'Return type check' {
            It 'Accepts -Bearer, returns type Object[]' {
                (Get-TdpscRestrictedPersonSearch -Bearer $bearer).GetType().FullName | Should Be 'System.Object[]'

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
            }

            It 'Accepts -Bearer, first object returns type PSCustomObject' {
                (Get-TdpscRestrictedPersonSearch -Bearer $bearer)[0].GetType().FullName | Should Be 'System.Management.Automation.PSCustomObject'

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
            }
        }
    }

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

                $tmp.GetType().FullName | Should Be 'System.Management.Automation.PSCustomObject', 'TeamDynamix.Api.Users.User'
                $tmp.UserName | Should Be 'MyUser@example.com'
            }
        }
    }

    Describe 'New-TdpscPersonImport' {
        Mock Get-UploadBoundaryEncodedByte -ModuleName teamdynamix-psclient -ParameterFilter {$Path -eq 'TestDrive:\import.xlsx'} {
            Write-Debug -Message 'Get-UploadBoundaryEncodedByte'
            Write-Debug -Message "`t[Path] $Path"

            ''
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Post' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'people/import')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{StatusDescription = 'OK'}
        }

        Context 'Passing with parameter' {
            It 'Accepts -Bearer and -Path' {
                $xlsxFile   = 'TestDrive:\import.xlsx'
                '-no-data-' | Set-Content -Path $xlsxFile

                New-TdpscPersonImport -Bearer $bearer -Path $xlsxFile | Should Be 'OK'
            }
        }

        Context 'Passing bearer from pipeline' {
            It 'Accepts -Path' {
                $xlsxFile   = 'TestDrive:\import.xlsx'
                '-no-data-' | Set-Content -Path $xlsxFile

                $bearer | New-TdpscPersonImport -Path $xlsxFile | Should Be 'OK'
            }
        }

        Context 'Passing without parameter name' {
            It 'Accepts with Bearer and Path (Fails in 1.0.0.5 and earlier)' {
                $xlsxFile   = 'TestDrive:\import.xlsx'
                '-no-data-' | Set-Content -Path $xlsxFile

                New-TdpscPersonImport $bearer $xlsxFile | Should Be 'OK'
            }
        }
    }

    Describe 'Remove-TdpscPersonFunctionalRole' {
        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Delete' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'people/313f362a-b885-4ea9-996a-6cc9c9eb039b/functionalroles/12')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{StatusDescription = 'OK'}
        }

        Mock Get-InternalBearer -ModuleName teamdynamix-psclient {
            Write-Debug -Message 'Get-InternalBearer'

            $bearer
        }
        
        Context 'Examples' {
            It 'Accepts -UID and -RoleID' {
                $tmp = Remove-TdpscPersonFunctionalRole -UID '313f362a-b885-4ea9-996a-6cc9c9eb039b' -RoleID 12

                $tmp | Should Be 'OK'
            }
        }
    }

    Describe 'Remove-TdpscPersonGroup' {
        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Delete' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'people/313f362a-b885-4ea9-996a-6cc9c9eb039b/groups/12')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{StatusDescription = 'OK'}
        }

        Mock Get-InternalBearer -ModuleName teamdynamix-psclient {
            Write-Debug -Message 'Get-InternalBearer'

            $bearer
        }
        
        Context 'Examples' {
            It 'Accepts -UID and -GroupID' {
                $tmp = Remove-TdpscPersonGroup -UID '313f362a-b885-4ea9-996a-6cc9c9eb039b' -GroupID 12

                $tmp | Should Be 'OK'
            }
        }
    }

    Describe 'Set-TdpscPerson' {
        Mock Get-InternalBearer -ModuleName teamdynamix-psclient {
            Write-Debug -Message 'Get-InternalBearer'

            $bearer
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Get' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'people/313f362a-b885-4ea9-996a-6cc9c9eb039b')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"
            Write-Debug -Message "`t[UID]    $UID"

            [PSCustomObject]@{Content = $restGetPerson}
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Post' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'people/313f362a-b885-4ea9-996a-6cc9c9eb039b')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"
            Write-Debug -Message "`t[UID]    $UID"

            [PSCustomObject]@{Content = $restGetPerson}
        }

        Context 'Passing with parameter' {
            It 'Accepts -Bearer and -Person parameter' {
                $UID = '313f362a-b885-4ea9-996a-6cc9c9eb039b'
                $NewPerson = $newPersonJson | ConvertFrom-Json
                $NewPerson.DefaultAccountID = 33616
                $NewPerson.WorkCity = ''
                $NewPerson.UID = $UID
                (Set-TdpscPerson -Bearer $bearer -Person $NewPerson).UID | Should Be $UID
            }
        }

        Context 'Passing bearer from pipeline' {
            It 'Accepts -Person' {
                $UID = '313f362a-b885-4ea9-996a-6cc9c9eb039b'
                $NewPerson = $newPersonJson | ConvertFrom-Json
                $NewPerson.DefaultAccountID = 33616
                $NewPerson.WorkCity = ''
                $NewPerson.UID = $UID
                ($bearer | Set-TdpscPerson -Person $NewPerson).UID | Should Be $UID
            }

            It 'Accepts with Person (Fails in 1.0.0.5 and earlier)' {
                $UID = '313f362a-b885-4ea9-996a-6cc9c9eb039b'
                $NewPerson = $newPersonJson | ConvertFrom-Json
                $NewPerson.DefaultAccountID = 33616
                $NewPerson.WorkCity = ''
                $NewPerson.UID = $UID
                ($bearer | Set-TdpscPerson $NewPerson).UID | Should Be $UID
            }
        }

        Context 'Passing without parameter name' {
            It 'Accepts with Bearer and -Person' {
                $UID = '313f362a-b885-4ea9-996a-6cc9c9eb039b'
                $NewPerson = $newPersonJson | ConvertFrom-Json
                $NewPerson.DefaultAccountID = 33616
                $NewPerson.WorkCity = ''
                $NewPerson.UID = $UID
                (Set-TdpscPerson $bearer -Person $NewPerson).UID | Should Be $UID
            }

            It 'Accepts with Bearer and Person (Fails in 1.0.0.5 and earlier)' {
                $UID = '313f362a-b885-4ea9-996a-6cc9c9eb039b'
                $NewPerson = $newPersonJson | ConvertFrom-Json
                $NewPerson.DefaultAccountID = 33616
                $NewPerson.WorkCity = ''
                $NewPerson.UID = $UID
                (Set-TdpscPerson $bearer $NewPerson).UID | Should Be $UID
            }
        }

        Context 'Examples' {
            It 'Accepts by named parameter' {
                $UID = '313f362a-b885-4ea9-996a-6cc9c9eb039b'
                $tmp = Set-TdpscPerson -UID '313f362a-b885-4ea9-996a-6cc9c9eb039b' -AlertEmail 'MyUser0001@example.com' -PrimaryEmail 'MyUser0001@example.com' -AuthenticationUserName 'MyUser0001@example.com' -FirstName 'JohnMyUser0001' -LastName 'DoeMyUser0001'

                $tmp.UID | Should Be $UID
            }

            It 'Accepts pipeline with named parameter' {
                $UID = '313f362a-b885-4ea9-996a-6cc9c9eb039b'
                $tmp = Get-TdpscPerson -UID $UID | Set-TdpscPerson -FirstName 'John' -LastName 'Doe'

                $tmp.UID | Should Be $UID
            }
        }
    }

    Describe 'Set-TdpscPersonFunctionalRole' {
        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Put' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'people/313f362a-b885-4ea9-996a-6cc9c9eb039b/functionalroles/6586?isPrimary=True')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{StatusDescription = 'OK'}
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Put' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'people/313f362a-b885-4ea9-996a-6cc9c9eb039b/functionalroles/6586?isPrimary=False')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{StatusDescription = 'OK'}
        }

        Mock Get-InternalBearer -ModuleName teamdynamix-psclient {
            Write-Debug -Message 'Get-InternalBearer'

            $bearer
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Get' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'people/313f362a-b885-4ea9-996a-6cc9c9eb039b')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"
            Write-Debug -Message "`t[UID]    $UID"

            [PSCustomObject]@{Content = $restGetPerson}
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Get' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'people/313f362a-b885-4ea9-996a-6cc9c9eb039b/functionalroles')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"
            Write-Debug -Message "`t[Body]   $Body"

            [PSCustomObject]@{Content = $restGetFunctionalRoles}
        }

        Context 'Examples' {
            It 'Accepts adding roles by -UID, -RoleID, and -IsPrimary' {
                $tmp = Set-TdpscPersonFunctionalRole -UID '313f362a-b885-4ea9-996a-6cc9c9eb039b' -RoleID 6586 -IsPrimary $true

                $tmp | Should Be 'OK'
            }

            It 'Accepts pipeline and adding roles by -RoleID' {
                $tmp = Get-TdpscPerson -UID '313f362a-b885-4ea9-996a-6cc9c9eb039b' | Set-TdpscPersonFunctionalRole -RoleID 6586

                $tmp | Should Be 'OK'
            }
        }
    }

    Describe 'Set-TdpscPersonGroup' {
        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Put' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'people/313f362a-b885-4ea9-996a-6cc9c9eb039b/groups/3863?isPrimary=True&isNotified=False&isManager=False')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{StatusDescription = 'OK'}
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Put' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'people/313f362a-b885-4ea9-996a-6cc9c9eb039b/groups/3862?isPrimary=False&isNotified=False&isManager=False')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{StatusDescription = 'OK'}
        }

        Mock Get-InternalBearer -ModuleName teamdynamix-psclient {
            Write-Debug -Message 'Get-InternalBearer'

            $bearer
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Get' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'people/313f362a-b885-4ea9-996a-6cc9c9eb039b')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"
            Write-Debug -Message "`t[UID]    $UID"

            [PSCustomObject]@{Content = $restGetPerson}
        }

        Context 'Examples' {
            It 'Accepts adding group by -UID, -GroupID, and -IsPrimary' {
                $tmp = Set-TdpscPersonGroup -UID '313f362a-b885-4ea9-996a-6cc9c9eb039b' -GroupID 3863 -IsPrimary $true

                $tmp | Should Be 'OK'
            }

            It 'Accepts pipeline and adding group by -GroupID' {
                $tmp = Get-TdpscPerson -UID '313f362a-b885-4ea9-996a-6cc9c9eb039b' | Set-TdpscPersonGroup -GroupID 3862

                $tmp | Should Be 'OK'
            }
        }
    }
}

Remove-Module -Name teamdynamix-psclient
