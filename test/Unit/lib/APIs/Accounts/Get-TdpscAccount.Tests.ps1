#Requires -Version 3

Set-StrictMode -Version 3

#Continue
#SilentlyContinue
$Script:DebugPreference   = 'SilentlyContinue'
$Script:VerbosePreference = 'SilentlyContinue'

Import-Module -Name "$PSScriptRoot\..\..\..\..\..\teamdynamix-psclient"

InModuleScope teamdynamix-psclient {
    $bearer          = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1bmlxdWVfbmFtZSI6InVzZXJAbG9jYWwiLCJpc3MiOiJURCIsImF1ZCI6Imh0dHBzOi8vd3d3LnRlYW1keW5hbWl4LmNvbS8iLCJleHAiOjE0NTgwNDg2NTEsIm5iZiI6MTQ1Nzk2MjI1MX0.DYFzy8Q9Nn0sR7fY-28vY8GHhRTn1aFe36BHy9u_J2w'
    $account1        = '{"ID":1,"Name":"Testing Division","IsActive":true,"Address1":"","Address2":"","Address3":"","Address4":"","City":"","StateName":"","StateAbbr":"  ","PostalCode":"","Country":"","Phone":"","Fax":"","Url":"","Notes":"","CreatedDate":"\/Date(1456247820000)\/","ModifiedDate":"\/Date(1456247820000)\/","Code":"","IndustryID":0,"IndustryName":"","Domain":""}'
    $account2        = '{"ID":2,"Name":"Awesome Department","IsActive":true,"Address1":"","Address2":"","Address3":"","Address4":"","City":"","StateName":"","StateAbbr":"  ","PostalCode":"","Country":"","Phone":"","Fax":"","Url":"","Notes":"","CreatedDate":"\/Date(1456247820000)\/","ModifiedDate":"\/Date(1456247820000)\/","Code":"","IndustryID":0,"IndustryName":"","Domain":""}'
    $restAccountGet  = "[$account1,$account2]"

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

    Describe 'Get-TdpscAccount' {
        Mock Get-InternalBearer -ModuleName teamdynamix-psclient {
            Write-Debug -Message 'Get-InternalBearer'

            $bearer
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Post' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'accounts/search') -and $Body -eq '{"SearchText":"e"}'} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"
            Write-Debug -Message "`t[Body]   $Body"

            [PSCustomObject]@{Content = $restAccountGet}
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Post' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'accounts/search') -and $Body -eq '{"SearchText":"e","ManagerUids":null,"CustomAttributes":null,"IsActive":null,"MaxResults":null}'} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"
            Write-Debug -Message "`t[Body]   $Body"

            [PSCustomObject]@{Content = $restAccountGet}
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Post' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'accounts/search') -and $Body -eq '{"SearchText":"New Department","ManagerUids":null,"CustomAttributes":null,"IsActive":null,"MaxResults":1}'} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"
            Write-Debug -Message "`t[Body]   $Body"

            [PSCustomObject]@{Content = ''}
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Post' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'accounts/search') -and $Body -eq '{"SearchText":"Awesome","ManagerUids":null,"CustomAttributes":null,"IsActive":null,"MaxResults":1}'} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"
            Write-Debug -Message "`t[Body]   $Body"

            [PSCustomObject]@{Content = "[$account2]"}
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Post' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'accounts/search') -and $Body -eq '{"SearchText":"New Department"}'} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"
            Write-Debug -Message "`t[Body]   $Body"

            [PSCustomObject]@{Content = ''}
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Post' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'accounts/search') -and $Body -eq '{"SearchText":"Testing Division"}'} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"
            Write-Debug -Message "`t[Body]   $Body"

            [PSCustomObject]@{Content = "[$account1]"}
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Get' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'accounts')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"
            Write-Debug -Message "`t[Body]   $Body"

            [PSCustomObject]@{Content = $restAccountGet}
        }

        Context 'Passing with parameter' {
            It 'Accepts -Bearer' {
                (Get-TdpscAccount -Bearer $bearer).Count | Should BeGreaterThan 0

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
            }

            It 'Accepts with empty -Bearer (Fails in 1.0.0.4 and earlier)' {
                {Get-TdpscAccount -Bearer ''} | Should Not Throw

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
            }

            It 'Accepts with null -Bearer (Fails in 1.0.0.4 and earlier)' {
                {Get-TdpscAccount -Bearer $null} | Should Not Throw

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
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

            It 'Fails with empty Bearer (Fails in 1.0.0.4 and earlier)' {
                {Get-TdpscAccount ''} | Should Not Throw

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
            }

            It 'Fails with null Bearer (Fails in 1.0.0.4 and earlier)' {
                {Get-TdpscAccount $null} | Should Not Throw

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
            }
        }

        Context 'Return type check' {
            It 'Accepts -Bearer, returns type Object[]' {
                (Get-TdpscAccount -Bearer $bearer).GetType().FullName | Should Be 'System.Object[]'

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
            }

            It 'Accepts -Bearer, first object returns type Account or PSCustomObject' {
                (Get-TdpscAccount -Bearer $bearer)[0].GetType().FullName | Should -BeIn @('TeamDynamix.Api.Accounts.Account', 'System.Management.Automation.PSCustomObject')

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
            }
        }

        Context 'Examples' {
            It 'Accepts retrieving accounts, use internal bearer, verify output type' {
                $tmp = Get-TdpscAccount

                $tmp.Count | Should Be 2
                $tmp.GetType().FullName | Should Be 'System.Object[]'
                $tmp[0].GetType().FullName | Should -BeIn @('System.Management.Automation.PSCustomObject', 'TeamDynamix.Api.Accounts.Account')
            }

            It 'Accepts account by ID, use internal bearer, verify returned name, verify output type' {
                $tmp = Get-TdpscAccount -ID 2

                $tmp.Name | Should Be 'Awesome Department'
                $tmp.GetType().FullName | Should -BeIn @('System.Management.Automation.PSCustomObject', 'TeamDynamix.Api.Accounts.Account')

            }

            It 'Fails with invalid account by ID' {
                $tmp = Get-TdpscAccount -ID 9000

                $tmp | Should Be $null
            }

            It 'Accepts account by name, use internal bearer, verify returned name, verify output type' {
                $tmp = Get-TdpscAccount -Name 'Testing Division'

                $tmp.Name | Should Be 'Testing Division'
                $tmp.GetType().FullName | Should -BeIn @('System.Management.Automation.PSCustomObject', 'TeamDynamix.Api.Accounts.Account')

            }

            It 'Fails with invalid account by name' {
                $tmp = Get-TdpscAccount -Name 'New Department'

                $tmp | Should Be $null
            }

            It 'Accepts account by Search, use internal bearer, verify returned name, verify output type' {
                $tmp = Get-TdpscAccount -Search @{'SearchText' = 'Testing Division'}

                $tmp.Name | Should Be 'Testing Division'
                $tmp.GetType().FullName | Should -BeIn @('System.Management.Automation.PSCustomObject', 'TeamDynamix.Api.Accounts.Account')
            }

            It 'Accepts account by Search, use internal bearer, returns multiple accounts, verify returned name, verify output type' {
                $tmp = Get-TdpscAccount -Search @{'SearchText' = 'e'}

                $tmp.Count | Should Be 2
                $tmp.GetType().FullName | Should Be 'System.Object[]'
                $tmp[0].GetType().FullName | Should -BeIn @('System.Management.Automation.PSCustomObject', 'TeamDynamix.Api.Accounts.Account')
            }

            It 'Fails with invalid account by Search' {
                $tmp = Get-TdpscAccount -Search @{'SearchText' = 'New Department'}

                $tmp | Should Be $null
            }

            It 'Accepts account by Search with type [TeamDynamix.Api.Accounts.AccountSearch], use internal bearer, verify returned name, verify output type' {
                $accountSearch = New-Object -TypeName TeamDynamix.Api.Accounts.AccountSearch
                $accountSearch.SearchText = 'Awesome'
                $accountSearch.MaxResults = 1
                $tmp = Get-TdpscAccount -Search $accountSearch

                $tmp.Name | Should Be 'Awesome Department'
                $tmp.GetType().FullName | Should -BeIn @('System.Management.Automation.PSCustomObject', 'TeamDynamix.Api.Accounts.Account')
            }

            It 'Accepts account by Search with type [TeamDynamix.Api.Accounts.AccountSearch], use internal bearer, returns multiple accounts, verify returned name, verify output type' {
                $accountSearch = New-Object -TypeName TeamDynamix.Api.Accounts.AccountSearch
                $accountSearch.SearchText = 'e'
                $tmp = Get-TdpscAccount -Search $accountSearch

                $tmp.Count | Should Be 2
                $tmp.GetType().FullName | Should Be 'System.Object[]'
                $tmp[0].GetType().FullName | Should -BeIn @('System.Management.Automation.PSCustomObject', 'TeamDynamix.Api.Accounts.Account')
            }

            It 'Fails with invalid account by Search with type [TeamDynamix.Api.Accounts.AccountSearch]' {
                $accountSearch = New-Object -TypeName TeamDynamix.Api.Accounts.AccountSearch
                $accountSearch.SearchText = 'New Department'
                $accountSearch.MaxResults = 1
                $tmp = Get-TdpscAccount -Search $accountSearch

                $tmp | Should Be $null
            }
        }
    }
}

Remove-Module -Name teamdynamix-psclient
