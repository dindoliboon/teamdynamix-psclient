#Requires -Version 3

Set-StrictMode -Version 3

#Continue
#SilentlyContinue
$Script:DebugPreference   = 'SilentlyContinue'
$Script:VerbosePreference = 'SilentlyContinue'

Clear-Host

Import-Module -Name "$PSScriptRoot\..\..\teamdynamix-psclient"

InModuleScope teamdynamix-psclient {
    $bearer   = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1bmlxdWVfbmFtZSI6InVzZXJAbG9jYWwiLCJpc3MiOiJURCIsImF1ZCI6Imh0dHBzOi8vd3d3LnRlYW1keW5hbWl4LmNvbS8iLCJleHAiOjE0NTgwNDg2NTEsIm5iZiI6MTQ1Nzk2MjI1MX0.DYFzy8Q9Nn0sR7fY-28vY8GHhRTn1aFe36BHy9u_J2w'

    $restAccountGet = '[{"ID":1,"Name":"Testing Division","IsActive":true,"Address1":"","Address2":"","Address3":"","Address4":"","City":"","StateName":"","StateAbbr":"  ","PostalCode":"","Country":"","Phone":"","Fax":"","Url":"","Notes":"","CreatedDate":"\/Date(1456247820000)\/","ModifiedDate":"\/Date(1456247820000)\/","Code":"","IndustryID":0,"IndustryName":"","Domain":""},{"ID":2,"Name":"Information Technology Services","IsActive":true,"Address1":"","Address2":"","Address3":"","Address4":"","City":"","StateName":"","StateAbbr":"  ","PostalCode":"","Country":"","Phone":"","Fax":"","Url":"","Notes":"","CreatedDate":"\/Date(1456247820000)\/","ModifiedDate":"\/Date(1456247820000)\/","Code":"","IndustryID":0,"IndustryName":"","Domain":""}]'

    Describe 'Get-TdpscAccount' {
        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Get' -and $URI -eq 'https://app.teamdynamix.com/TDWebApi/api/accounts'} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{Content = $restAccountGet}
        }

        # Generic catch-all. This will throw an exception if we forgot to mock something.
        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient {
            Write-Verbose -Message 'Mocked Invoke-WebRequest with no parameter filter.'
            Write-Verbose -Message "`t[Method] $Method"
            Write-Verbose -Message "`t[URI]    $URI"

            throw "Unidentified call to Invoke-WebRequest"
        }

        Context 'Passing with parameter' {
            It 'Accepts -Bearer' {
                (Get-TdpscAccount -Bearer $bearer).Count | Should BeGreaterThan 0

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
            }

            It 'Fails with empty -Bearer' {
                {Get-TdpscAccount -Bearer ''} | Should Throw

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 0 -Scope It
            }

            It 'Fails with null -Bearer' {
                {Get-TdpscAccount -Bearer $null} | Should Throw

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 0 -Scope It
            }
        }

        Context 'Passing from pipeline' {
            It 'Accepts Bearer' {
                ($bearer | Get-TdpscAccount).Count | Should BeGreaterThan 0

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
            }
        }

        Context 'Passing without parameter name' {
            It 'Accepts Bearer' {
                (Get-TdpscAccount $bearer).Count | Should BeGreaterThan 0

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
            }

            It 'Fails with empty Bearer' {
                {Get-TdpscAccount ''} | Should Throw

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 0 -Scope It
            }

            It 'Fails with null Bearer' {
                {Get-TdpscAccount $null} | Should Throw

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 0 -Scope It
            }
        }

        Context 'Return type check' {
            It 'Accepts -Bearer, returns type Object[]' {
                (Get-TdpscAccount -Bearer $bearer).GetType().FullName | Should Be 'System.Object[]'

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
            }

            It 'Accepts -Bearer, first object returns type Account or PSCustomObject' {
                (Get-TdpscAccount -Bearer $bearer)[0].GetType().FullName | Should Be 'TeamDynamix.Api.Accounts.Account', 'System.Management.Automation.PSCustomObject'
            
                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
            }
        }
    }
}

Remove-Module -Name teamdynamix-psclient
