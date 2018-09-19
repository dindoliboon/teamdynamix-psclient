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

    Describe 'Set-TdpscAccount' {
        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Put' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'accounts/1') -and $Body -eq '{"ID":1,"Name":"Testing Division","IsActive":true,"Address1":"","Address2":"","Address3":"","Address4":"","City":"Anytown","StateName":"","StateAbbr":"USA","PostalCode":"12345","Country":"USA","Phone":"555-555-5555","Fax":"","Url":"","Notes":"","CreatedDate":"\/Date(1456247820000)\/","ModifiedDate":"\/Date(1456247820000)\/","Code":"","IndustryID":0,"IndustryName":"","Domain":""}'} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"
            Write-Debug -Message "`t[Body]   $Body"

            [PSCustomObject]@{Content = $Body}
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Put' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'accounts/2') -and $Body -eq '{"ID":2,"Name":"Awesome Department","IsActive":true,"Address1":"","Address2":"","Address3":"","Address4":"","City":"Anytown","StateName":"","StateAbbr":"USA","PostalCode":"12345","Country":"USA","Phone":"555-555-5555","Fax":"","Url":"","Notes":"","CreatedDate":"\/Date(1456247820000)\/","ModifiedDate":"\/Date(1456247820000)\/","Code":"","IndustryID":0,"IndustryName":"","Domain":""}'} {
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

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Get' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'accounts')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"
            Write-Debug -Message "`t[Body]   $Body"

            [PSCustomObject]@{Content = $restAccountGet}
        }

        Context 'Examples' {
            It 'Accepts updating account, uses -ID' {
                $tmp = Set-TdpscAccount -ID 1 -City 'Anytown' -StateAbbr 'USA' -PostalCode '12345' -Country 'USA' -Phone '555-555-5555'

                $tmp.GetType().FullName | Should -BeIn @('System.Management.Automation.PSCustomObject', 'TeamDynamix.Api.Accounts.Account')
                $tmp.City | Should Be 'Anytown'
            }

            It 'Accepts updating account, uses Get-TdpscAccount -ID with pipeline' {
                $tmp = Get-TdpscAccount -ID 1 | Set-TdpscAccount -City 'Anytown' -StateAbbr 'USA' -PostalCode '12345' -Country 'USA' -Phone '555-555-5555'

                $tmp.GetType().FullName | Should -BeIn @('System.Management.Automation.PSCustomObject', 'TeamDynamix.Api.Accounts.Account')
                $tmp.City | Should Be 'Anytown'
            }

            It 'Accepts updating multiple accounts, uses Get-TdpscAccount -ID with pipeline' {
                $tmp = (Get-TdpscAccount -ID 1), (Get-TdpscAccount -ID 2) | Set-TdpscAccount -City 'Anytown' -StateAbbr 'USA' -PostalCode '12345' -Country 'USA' -Phone '555-555-5555'

                $tmp.GetType().FullName | Should Be 'System.Object[]'
                $tmp[0].GetType().FullName | Should -BeIn @('System.Management.Automation.PSCustomObject', 'TeamDynamix.Api.Accounts.Account')
                $tmp[0].City | Should Be 'Anytown'
                $tmp.Count | Should Be 2
            }

            It 'Accepts updating multiple accounts, uses Get-TdpscAccount and Where-Object with pipeline' {
                $tmp = Get-TdpscAccount | Where-Object {$_.ID -eq 1 -or $_.ID -eq 2} | Set-TdpscAccount -City 'Anytown' -StateAbbr 'USA' -PostalCode '12345' -Country 'USA' -Phone '555-555-5555'

                $tmp.GetType().FullName | Should Be 'System.Object[]'
                $tmp[0].GetType().FullName | Should -BeIn @('System.Management.Automation.PSCustomObject', 'TeamDynamix.Api.Accounts.Account')
                $tmp[0].City | Should Be 'Anytown'
                $tmp.Count | Should Be 2
            }
        }
    }
}

Remove-Module -Name teamdynamix-psclient
