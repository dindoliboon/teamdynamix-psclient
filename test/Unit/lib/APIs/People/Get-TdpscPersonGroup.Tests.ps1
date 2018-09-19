#Requires -Version 3

Set-StrictMode -Version 3

#Continue
#SilentlyContinue
$Script:DebugPreference   = 'SilentlyContinue'
$Script:VerbosePreference = 'SilentlyContinue'

Import-Module -Name "$PSScriptRoot\..\..\..\..\..\teamdynamix-psclient"

InModuleScope teamdynamix-psclient {
    $bearer                 = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1bmlxdWVfbmFtZSI6InVzZXJAbG9jYWwiLCJpc3MiOiJURCIsImF1ZCI6Imh0dHBzOi8vd3d3LnRlYW1keW5hbWl4LmNvbS8iLCJleHAiOjE0NTgwNDg2NTEsIm5iZiI6MTQ1Nzk2MjI1MX0.DYFzy8Q9Nn0sR7fY-28vY8GHhRTn1aFe36BHy9u_J2w'
    $group1                 = '{"ID":1,"FunctionalRoleID":1,"UID":"14c88477-25d4-e511-b52c-000d3a113111","FunctionalRoleName":null,"StandardRate":0.0,"CostRate":100.0,"CreatedDate":"2016-02-15T20:48:36.737Z","Comments":null,"IsPrimary":false}'
    $group2                 = '{"ID":2,"FunctionalRoleID":2,"UID":"14c88477-25d4-e511-b52c-000d3a113222","FunctionalRoleName":null,"StandardRate":0.0,"CostRate":200.0,"CreatedDate":"2016-02-18T15:33:39.53Z","Comments":"","IsPrimary":false}'
    $restGetGroups          = "[$group1,$group2]"

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
                $tmp[0].GetType().FullName | Should -BeIn @('System.Management.Automation.PSCustomObject', 'TeamDynamix.Api.Users.UserGroup')
                $tmp.Count | Should Be 2
            }

            It 'Accepts getting groups by pipeline' {
                $tmp = '313f362a-b885-4ea9-996a-6cc9c9eb039b' | Get-TdpscPersonGroup

                $tmp.GetType().FullName | Should Be 'System.Object[]'
                $tmp[0].GetType().FullName | Should -BeIn @('System.Management.Automation.PSCustomObject', 'TeamDynamix.Api.Users.UserGroup')
                $tmp.Count | Should Be 2
                $tmp[0].CostRate | Should Be 100
                $tmp[1].CostRate | Should Be 200
            }
        }
    }
}

Remove-Module -Name teamdynamix-psclient
