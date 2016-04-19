#Requires -Version 3

Set-StrictMode -Version 3

#Continue
#SilentlyContinue
$Script:DebugPreference   = 'SilentlyContinue'
$Script:VerbosePreference = 'SilentlyContinue'

Import-Module -Name "$PSScriptRoot\..\..\teamdynamix-psclient"

InModuleScope teamdynamix-psclient {
    $bearer    = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1bmlxdWVfbmFtZSI6InVzZXJAbG9jYWwiLCJpc3MiOiJURCIsImF1ZCI6Imh0dHBzOi8vd3d3LnRlYW1keW5hbWl4LmNvbS8iLCJleHAiOjE0NTgwNDg2NTEsIm5iZiI6MTQ1Nzk2MjI1MX0.DYFzy8Q9Nn0sR7fY-28vY8GHhRTn1aFe36BHy9u_J2w'
    $group1    = '{"ID":3874,"Name":"Test1","Description":"","IsActive":true,"CreatedDate":"2016-02-17T14:54:25.747Z","ModifiedDate":"2016-02-17T14:54:25.747Z"}'
    $group2    = '{"ID":3864,"Name":"GroupB","Description":"","IsActive":true,"CreatedDate":"2016-02-17T13:43:58.053Z","ModifiedDate":"2016-02-17T13:43:58.053Z"}'
    $groupsGet = "[$group1,$group2]"

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

    Describe 'Get-TdpscGroup' {
        Mock Get-InternalBearer -ModuleName teamdynamix-psclient {
            Write-Debug -Message 'Get-InternalBearer'

            $bearer
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Post' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'groups/search') -and $Body -eq '{"IsActive":null,"NameLike":"","HasAppID":null,"HasSystemAppName":""}'} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{Content = $groupsGet}
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Post' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'groups/search') -and $Body -eq '{"IsActive":null,"NameLike":"Group","HasAppID":null,"HasSystemAppName":""}'} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{Content = "[$group2]"}
        }

        Context 'Examples' {
            It 'Accepts with no parameters' {
                $tmp = Get-TdpscGroup

                $tmp.Count | Should Be 2
            }

            It 'Accepts with -NameLike' {
                $tmp = Get-TdpscGroup -NameLike 'Group'

                $tmp.Count | Should Be 1
            }
        }
    }
}

Remove-Module -Name teamdynamix-psclient
