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

    Describe 'New-TdpscAccount' {
        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Post' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'accounts') -and $Body -eq '{"ID":0,"Name":"Already Exists","IsActive":true,"Address1":"","Address2":"","Address3":"","Address4":"","City":"Anytown","StateName":null,"StateAbbr":"USA","PostalCode":"12345","Country":"USA","Phone":"555-555-5555","Fax":"","Url":"","Notes":"","CreatedDate":"\/Date(-62135578800000)\/","ModifiedDate":"\/Date(-62135578800000)\/","Code":"","IndustryID":0,"IndustryName":null,"Domain":""}'} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"
            Write-Debug -Message "`t[Body]   $Body"

            [PSCustomObject]@{Content = ''}
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Post' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'accounts') -and $Body -eq '{"ID":0,"Name":"Awesome Department","IsActive":true,"Address1":"","Address2":"","Address3":"","Address4":"","City":"Anytown","StateName":null,"StateAbbr":"USA","PostalCode":"12345","Country":"USA","Phone":"555-555-5555","Fax":"","Url":"","Notes":"","CreatedDate":"\/Date(-62135578800000)\/","ModifiedDate":"\/Date(-62135578800000)\/","Code":"","IndustryID":0,"IndustryName":null,"Domain":""}'} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"
            Write-Debug -Message "`t[Body]   $Body"

            [PSCustomObject]@{Content = $Body}
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Post' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'accounts') -and $Body -eq '{"ID":0,"Name":"New Awesome Department","IsActive":true,"Address1":"","Address2":"","Address3":"","Address4":"","City":"Anytown","StateName":null,"StateAbbr":"USA","PostalCode":"12345","Country":"USA","Phone":"555-555-5555","Fax":"","Url":"","Notes":"","CreatedDate":"\/Date(-62135578800000)\/","ModifiedDate":"\/Date(-62135578800000)\/","Code":"","IndustryID":0,"IndustryName":null,"Domain":""}'} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"
            Write-Debug -Message "`t[Body]   $Body"

            [PSCustomObject]@{Content = $Body}
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Post' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'accounts') -and $Body -eq '{"ID":0,"Name":"Awesome Department","IsActive":true,"Address1":"","Address2":"","Address3":"","Address4":"","City":"","StateName":null,"StateAbbr":"","PostalCode":"","Country":"","Phone":"555-555-5555","Fax":"","Url":"","Notes":"","CreatedDate":"\/Date(-62135578800000)\/","ModifiedDate":"\/Date(-62135578800000)\/","Code":"","IndustryID":0,"IndustryName":null,"Domain":""}'} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"
            Write-Debug -Message "`t[Body]   $Body"

            [PSCustomObject]@{Content = $Body}
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Post' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'accounts') -and $Body -eq '{"ID":2,"Name":"Awesome Department","IsActive":true,"Address1":"","Address2":"","Address3":"","Address4":"","City":"","StateName":"","StateAbbr":"  ","PostalCode":"","Country":"","Phone":"","Fax":"","Url":"","Notes":"","CreatedDate":"\/Date(1456247820000)\/","ModifiedDate":"\/Date(1456247820000)\/","Code":"","IndustryID":0,"IndustryName":"","Domain":""}'} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"
            Write-Debug -Message "`t[Body]   $Body"

            [PSCustomObject]@{Content = $Body}
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Get' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'accounts')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"
            Write-Debug -Message "`t[Body]   $Body"

            [PSCustomObject]@{Content = $restAccountGet}
        }

        Mock Get-InternalBearer -ModuleName teamdynamix-psclient {
            Write-Debug -Message 'Get-InternalBearer'

            $bearer
        }

        Context 'Examples' {
            It 'Accepts creating new account, use internal bearer, verify output type' {
                $tmp = New-TdpscAccount -Name 'Awesome Department' -City 'Anytown' -StateAbbr 'USA' -PostalCode '12345' -Country 'USA' -Phone '555-555-5555'

                $tmp.GetType().FullName | Should -BeIn @('System.Management.Automation.PSCustomObject', 'TeamDynamix.Api.Accounts.Account')
                $tmp.Name | Should Be 'Awesome Department'
            }

            It 'Fails creating new account that already exists' {
                $tmp = New-TdpscAccount -Name 'Already Exists' -City 'Anytown' -StateAbbr 'USA' -PostalCode '12345' -Country 'USA' -Phone '555-555-5555'

                $tmp | Should Be $null
            }

            It 'Accepts creating new account, use Account and -Name with pipeline' {
                $account = New-Object -TypeName TeamDynamix.Api.Accounts.Account
                $account.Name       = 'Awesome Department'
                $account.City       = 'Anytown'
                $account.StateAbbr  = 'USA'
                $account.PostalCode = '12345'
                $account.Country    = 'USA'
                $account.Phone      = '555-555-5555'
                $tmp = $account | New-TdpscAccount -Name 'New Awesome Department'

                $tmp.GetType().FullName | Should -BeIn @('System.Management.Automation.PSCustomObject', 'TeamDynamix.Api.Accounts.Account')
                $tmp.Name | Should Be 'New Awesome Department'
            }

            It 'Accepts creating new account, use Account with pipeline' {
                $account = New-Object -TypeName TeamDynamix.Api.Accounts.Account
                $account.Name  = 'Awesome Department'
                $account.Phone = '555-555-5555'
                $tmp = $account | New-TdpscAccount

                $tmp.GetType().FullName | Should -BeIn @('System.Management.Automation.PSCustomObject', 'TeamDynamix.Api.Accounts.Account')
                $tmp.Name | Should Be 'Awesome Department'
            }

            It 'Accepts creating new account, use PSObject with pipeline' {
                $account = New-Object -TypeName PSObject -Property @{
                    Name  = 'Awesome Department'
                    Phone = '555-555-5555'
                }
                $tmp = $account | New-TdpscAccount

                $tmp.GetType().FullName | Should -BeIn @('System.Management.Automation.PSCustomObject', 'TeamDynamix.Api.Accounts.Account')
                $tmp.Name | Should Be 'Awesome Department'
            }

            It 'Accepts creating new account, use Get-TdpscAccount -ID with pipeline' {
                $tmp = Get-TdpscAccount -ID 2 | New-TdpscAccount -Name 'Awesome Department'

                $tmp.GetType().FullName | Should -BeIn @('System.Management.Automation.PSCustomObject', 'TeamDynamix.Api.Accounts.Account')
                $tmp.Name | Should Be 'Awesome Department'
            }
        }
    }
}

Remove-Module -Name teamdynamix-psclient
