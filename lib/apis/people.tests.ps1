#Requires -Version 3

Set-StrictMode -Version 3

#Continue
#SilentlyContinue
$Script:DebugPreference   = 'SilentlyContinue'
$Script:VerbosePreference = 'SilentlyContinue'

Import-Module -Name "$PSScriptRoot\..\..\teamdynamix-psclient"

InModuleScope teamdynamix-psclient {
    $bearer           = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1bmlxdWVfbmFtZSI6InVzZXJAbG9jYWwiLCJpc3MiOiJURCIsImF1ZCI6Imh0dHBzOi8vd3d3LnRlYW1keW5hbWl4LmNvbS8iLCJleHAiOjE0NTgwNDg2NTEsIm5iZiI6MTQ1Nzk2MjI1MX0.DYFzy8Q9Nn0sR7fY-28vY8GHhRTn1aFe36BHy9u_J2w'
    $restPeopleSearch = '[{"UID":"313f362a-b885-4ea9-996a-6cc9c9eb039b","BEID":"f23d3f8a-a752-4468-8fe2-dedb60a370b7","BEIDInt":190,"IsActive":true,"FullName":"API User","FirstName":"API","LastName":"User","MiddleName":"","Birthday":"0001-01-01T05:00:00Z","Salutation":"","Nickname":"","DefaultAccountID":0,"DefaultAccountName":"None","PrimaryEmail":"","AlternateEmail":"","ExternalID":"","AlternateID":"","Applications":["TDAdmin"],"SecurityRoleName":"","SecurityRoleID":"","Permissions":[],"OrgApplications":[],"GroupIDs":[],"ReferenceID":1000000,"AlertEmail":"","Company":"","Title":"","HomePhone":"","PrimaryPhone":"","WorkPhone":"","Pager":"","OtherPhone":"","MobilePhone":"","Fax":"","DefaultPriorityID":0,"DefaultPriorityName":"None","AboutMe":null,"WorkAddress":"","WorkCity":"","WorkState":"","WorkZip":"","WorkCountry":"","HomeAddress":"","HomeCity":"","HomeState":"","HomeZip":"","HomeCountry":"","DefaultRate":0.0,"CostRate":0.0,"IsEmployee":true,"WorkableHours":8.0,"IsCapacityManaged":false,"ReportTimeAfterDate":"0001-01-01T00:00:00Z","EndDate":"0001-01-01T00:00:00Z","ShouldReportTime":false,"ReportsToUID":"","ReportsToFullName":"","ResourcePoolID":-1,"ResourcePoolName":"","TZID":2,"TZName":"(GMT-05:00)Eastern Time(US and Canada)","TypeID":3,"AuthenticationUserName":"","AuthenticationProviderID":0,"Attributes":[],"Gender":0,"IMProvider":"","IMHandle":""},{"UID":"313f362a-b885-4ea9-996a-6cc9c9eb0391","BEID":"f23d3f8a-a752-4468-8fe2-dedb60a370b1","BEIDInt":191,"IsActive":true,"FullName":"API User 2","FirstName":"API","LastName":"User 2","MiddleName":"","Birthday":"0001-01-01T05:00:00Z","Salutation":"","Nickname":"","DefaultAccountID":0,"DefaultAccountName":"None","PrimaryEmail":"","AlternateEmail":"","ExternalID":"","AlternateID":"","Applications":["TDAdmin"],"SecurityRoleName":"","SecurityRoleID":"","Permissions":[],"OrgApplications":[],"GroupIDs":[],"ReferenceID":1000001,"AlertEmail":"","Company":"","Title":"","HomePhone":"","PrimaryPhone":"","WorkPhone":"","Pager":"","OtherPhone":"","MobilePhone":"","Fax":"","DefaultPriorityID":0,"DefaultPriorityName":"None","AboutMe":null,"WorkAddress":"","WorkCity":"","WorkState":"","WorkZip":"","WorkCountry":"","HomeAddress":"","HomeCity":"","HomeState":"","HomeZip":"","HomeCountry":"","DefaultRate":0.0,"CostRate":0.0,"IsEmployee":true,"WorkableHours":8.0,"IsCapacityManaged":false,"ReportTimeAfterDate":"0001-01-01T00:00:00Z","EndDate":"0001-01-01T00:00:00Z","ShouldReportTime":false,"ReportsToUID":"","ReportsToFullName":"","ResourcePoolID":-1,"ResourcePoolName":"","TZID":2,"TZName":"(GMT-05:00)Eastern Time(US and Canada)","TypeID":3,"AuthenticationUserName":"","AuthenticationProviderID":0,"Attributes":[],"Gender":0,"IMProvider":"","IMHandle":""}]'
    $restGetPerson    = '{"UID":"313f362a-b885-4ea9-996a-6cc9c9eb039b","BEID":"f23d3f8a-a752-4468-8fe2-dedb60a370b7","BEIDInt":190,"IsActive":true,"FullName":"API User","FirstName":"API","LastName":"User","MiddleName":"","Birthday":"0001-01-01T05:00:00Z","Salutation":"","Nickname":"","DefaultAccountID":0,"DefaultAccountName":"None","PrimaryEmail":"","AlternateEmail":"","ExternalID":"","AlternateID":"","Applications":["TDAdmin"],"SecurityRoleName":"","SecurityRoleID":"","Permissions":[],"OrgApplications":[],"GroupIDs":[],"ReferenceID":1000000,"AlertEmail":"","Company":"","Title":"","HomePhone":"","PrimaryPhone":"","WorkPhone":"","Pager":"","OtherPhone":"","MobilePhone":"","Fax":"","DefaultPriorityID":0,"DefaultPriorityName":"None","AboutMe":null,"WorkAddress":"","WorkCity":"","WorkState":"","WorkZip":"","WorkCountry":"","HomeAddress":"","HomeCity":"","HomeState":"","HomeZip":"","HomeCountry":"","DefaultRate":0.0,"CostRate":0.0,"IsEmployee":true,"WorkableHours":8.0,"IsCapacityManaged":false,"ReportTimeAfterDate":"0001-01-01T00:00:00Z","EndDate":"0001-01-01T00:00:00Z","ShouldReportTime":false,"ReportsToUID":"","ReportsToFullName":"","ResourcePoolID":-1,"ResourcePoolName":"","TZID":2,"TZName":"(GMT-05:00)Eastern Time(US and Canada)","TypeID":3,"AuthenticationUserName":"","AuthenticationProviderID":0,"Attributes":[],"Gender":0,"IMProvider":"","IMHandle":""}'
    $newPersonJson    = '{"UID":"","BEID":"","BEIDInt":0,"IsActive":true,"FullName":"","FirstName":"","LastName":"","MiddleName":"","Birthday":"","Salutation":"","Nickname":"","DefaultAccountID":0,"DefaultAccountName":"","PrimaryEmail":"","AlternateEmail":"","ExternalID":"","AlternateID":"","Applications":[],"SecurityRoleName":"","SecurityRoleID":"","Permissions":[],"OrgApplications":[],"GroupIDs":[],"ReferenceID":0,"AlertEmail":"","Company":"","Title":"","HomePhone":"","PrimaryPhone":"","WorkPhone":"","Pager":"","OtherPhone":"","MobilePhone":"","Fax":"","DefaultPriorityID":0,"DefaultPriorityName":"None","AboutMe":null,"WorkAddress":"","WorkCity":"","WorkState":"","WorkZip":"","WorkCountry":"","HomeAddress":"","HomeCity":"","HomeState":"","HomeZip":"","HomeCountry":"","DefaultRate":0.0,"CostRate":0.0,"IsEmployee":true,"WorkableHours":8.0,"IsCapacityManaged":false,"ReportTimeAfterDate":"0001-01-01T00:00:00Z","EndDate":"0001-01-01T00:00:00Z","ShouldReportTime":false,"ReportsToUID":"","ReportsToFullName":"","ResourcePoolID":-1,"ResourcePoolName":"","TZID":2,"TZName":"(GMT-05:00)Eastern Time(US and Canada)","TypeID":3,"AuthenticationUserName":"","AuthenticationProviderID":0,"Attributes":[],"Gender":0,"IMProvider":"","IMHandle":""}'

    $searchText = 'John Doe'
    $maxResults = 25

    Describe 'Get-TdpscRestrictedPersonSearch' {
        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Get' -and $URI -eq "https://app.teamdynamix.com/TDWebApi/api/people/lookup?maxResults=$($maxResults)&searchText=$($searchText)"} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{Content = $restPeopleSearch}
        }

        # Generic catch-all. This will throw an exception if we forgot to mock something.
        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient {
            Write-Verbose -Message 'Mocked Invoke-WebRequest with no parameter filter.'
            Write-Verbose -Message "`t[Method] $Method"
            Write-Verbose -Message "`t[URI]    $URI"

            throw "Unidentified call to Invoke-WebRequest"
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

            It 'Fails with Bearer and SearchText' {
                {Get-TdpscRestrictedPersonSearch $bearer $searchText} | Should Throw
            }

            It 'Fails with Bearer, SearchText, and MaxResults' {
                {Get-TdpscRestrictedPersonSearch $bearer $searchText 75} | Should Throw
            }

            It 'Accepts Bearer and -SearchText' {
                (Get-TdpscRestrictedPersonSearch $bearer -SearchText $searchText).Count | Should BeGreaterThan 0
            }

            It 'Accepts Bearer, -SearchText, and -MaxResults' {
                $maxResults = 75
                (Get-TdpscRestrictedPersonSearch $bearer -SearchText $searchText -MaxResults $maxResults).Count | Should BeGreaterThan 0
            }

            It 'Fails with Bearer, SearchText, and -MaxResults' {
                {Get-TdpscRestrictedPersonSearch $bearer $searchText -MaxResults 75} | Should Throw
            }

            It 'Fails with -Bearer, SearchText, and -MaxResults' {
                {Get-TdpscRestrictedPersonSearch -Bearer $bearer $searchText -MaxResults 75} | Should Throw
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

    Describe 'Get-TdpscPersonSearch' {
        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Post' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'people/search')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{Content = $restPeopleSearch}
        }

        # Generic catch-all. This will throw an exception if we forgot to mock something.
        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient {
            Write-Verbose -Message 'Mocked Invoke-WebRequest with no parameter filter.'
            Write-Verbose -Message "`t[Method] $Method"
            Write-Verbose -Message "`t[URI]    $URI"

            throw "Unidentified call to Invoke-WebRequest"
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

            It 'Fails with Bearer and SearchText' {
                {Get-TdpscPersonSearch $bearer $searchText} | Should Throw
            }

            It 'Accepts Bearer and -SearchText' {
                (Get-TdpscPersonSearch $bearer -SearchText $searchText).Count | Should BeGreaterThan 0
            }

            It 'Accepts Bearer, -SearchText, and -MaxResults' {
                $maxResults = 75
                (Get-TdpscPersonSearch $bearer -SearchText $searchText -MaxResults $maxResults).Count | Should BeGreaterThan 0
            }

            It 'Fails with Bearer, SearchText, and -MaxResults' {
                {Get-TdpscPersonSearch $bearer $searchText -MaxResults 75} | Should Throw
            }

            It 'Fails with -Bearer, SearchText, and -MaxResults' {
                {Get-TdpscPersonSearch -Bearer $bearer $searchText -MaxResults 75} | Should Throw
            }
        }

        Context 'Return type check' {
            It 'Accepts -Bearer, returns type Object[]' {
                (Get-TdpscPersonSearch -Bearer $bearer).GetType().FullName | Should Be 'System.Object[]'

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
            }

            It 'Accepts -Bearer, first object returns type PSCustomObject' {
                (Get-TdpscPersonSearch -Bearer $bearer)[0].GetType().FullName | Should Be 'System.Management.Automation.PSCustomObject'

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
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

        # Generic catch-all. This will throw an exception if we forgot to mock something.
        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient {
            Write-Verbose -Message 'Mocked Invoke-WebRequest with no parameter filter.'
            Write-Verbose -Message "`t[Method] $Method"
            Write-Verbose -Message "`t[URI]    $URI"

            throw "Unidentified call to Invoke-WebRequest"
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
            It 'Fails with Bearer and Path' {
                $xlsxFile   = 'TestDrive:\import.xlsx'
                '-no-data-' | Set-Content -Path $xlsxFile

                {New-TdpscPersonImport $bearer $xlsxFile} | Should Throw
            }
        }
    }

    Describe 'Get-TdpscPerson' {
        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Get' -and $URI -eq "https://app.teamdynamix.com/TDWebApi/api/people/$($UID)"} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"
            Write-Debug -Message "`t[UID]    $UID"

            [PSCustomObject]@{Content = $restGetPerson}
        }

        # Generic catch-all. This will throw an exception if we forgot to mock something.
        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient {
            Write-Verbose -Message 'Mocked Invoke-WebRequest with no parameter filter.'
            Write-Verbose -Message "`t[Method] $Method"
            Write-Verbose -Message "`t[URI]    $URI"

            throw "Unidentified call to Invoke-WebRequest"
        }

        Context 'Passing with parameter' {
            It 'Accepts -Bearer and -UID' {
                $UID = '313f362a-b885-4ea9-996a-6cc9c9eb039b'
                
                (Get-TdpscPerson -Bearer $bearer -UID $UID).UID | Should Be $UID
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

            It 'Fails with Bearer and UID' {
                $UID = '313f362a-b885-4ea9-996a-6cc9c9eb039b'
                
                {Get-TdpscPerson $bearer $UID} | Should Throw
            }
        }

    }

    Describe 'Set-TdpscPerson' {
        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Post' -and $URI -eq "https://app.teamdynamix.com/TDWebApi/api/people/$($UID)"} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"
            Write-Debug -Message "`t[UID]    $UID"

            [PSCustomObject]@{Content = $restGetPerson}
        }

        # Generic catch-all. This will throw an exception if we forgot to mock something.
        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient {
            Write-Verbose -Message 'Mocked Invoke-WebRequest with no parameter filter.'
            Write-Verbose -Message "`t[Method] $Method"
            Write-Verbose -Message "`t[URI]    $URI"

            throw "Unidentified call to Invoke-WebRequest"
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
            It 'Fails with Person' {
                $UID = '313f362a-b885-4ea9-996a-6cc9c9eb039b'
                $NewPerson = $newPersonJson | ConvertFrom-Json
                $NewPerson.DefaultAccountID = 33616
                $NewPerson.WorkCity = ''
                $NewPerson.UID = $UID
                {$bearer | Set-TdpscPerson $NewPerson} | Should Throw
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

            It 'Fails with Bearer and Person' {
                $UID = '313f362a-b885-4ea9-996a-6cc9c9eb039b'
                $NewPerson = $newPersonJson | ConvertFrom-Json
                $NewPerson.DefaultAccountID = 33616
                $NewPerson.WorkCity = ''
                $NewPerson.UID = $UID
                {Set-TdpscPerson $bearer $NewPerson} | Should Throw
            }
        }
    }
}

Remove-Module -Name teamdynamix-psclient
