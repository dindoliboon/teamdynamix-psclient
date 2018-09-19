#Requires -Version 3

Set-StrictMode -Version 3

#Continue
#SilentlyContinue
$Script:DebugPreference   = 'SilentlyContinue'
$Script:VerbosePreference = 'SilentlyContinue'

Import-Module -Name "$PSScriptRoot\..\..\..\..\..\teamdynamix-psclient"

InModuleScope teamdynamix-psclient {
    $bearer        = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1bmlxdWVfbmFtZSI6InVzZXJAbG9jYWwiLCJpc3MiOiJURCIsImF1ZCI6Imh0dHBzOi8vd3d3LnRlYW1keW5hbWl4LmNvbS8iLCJleHAiOjE0NTgwNDg2NTEsIm5iZiI6MTQ1Nzk2MjI1MX0.DYFzy8Q9Nn0sR7fY-28vY8GHhRTn1aFe36BHy9u_J2w'
    $attributesGet = '[{"ID":21082,"Name":"Test1","Order":0,"Description":"","SectionID":0,"SectionName":null,"FieldType":"checklist","DataType":"String","Choices":[],"IsRequired":false,"IsUpdatable":false,"Value":"","ValueText":"","ChoicesText":null},{"ID":21083,"Name":"test2","Order":0,"Description":"","SectionID":0,"SectionName":null,"FieldType":"checklist","DataType":"String","Choices":[],"IsRequired":false,"IsUpdatable":false,"Value":"","ValueText":"","ChoicesText":null}]'

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

    Describe 'Get-TdpscCustomAttribute' {
        Mock Get-InternalBearer -ModuleName teamdynamix-psclient {
            Write-Debug -Message 'Get-InternalBearer'

            $bearer
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Get' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'attributes/custom?appId=0&associatedTypeId=0&componentId=63')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{Content = $attributesGet}
        }

        Context 'Examples' {
            It 'Accepts by -ID' {
                $tmp = Get-TdpscCustomAttribute -ComponentId 63

                $tmp.Count | Should Be 2
            }
        }
    }
}

Remove-Module -Name teamdynamix-psclient
