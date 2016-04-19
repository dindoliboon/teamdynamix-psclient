#Requires -Version 3

Set-StrictMode -Version 3

#Continue
#SilentlyContinue
$Script:DebugPreference   = 'SilentlyContinue'
$Script:VerbosePreference = 'SilentlyContinue'

Import-Module -Name "$PSScriptRoot\..\..\teamdynamix-psclient"

InModuleScope teamdynamix-psclient {
    $bearer      = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1bmlxdWVfbmFtZSI6InVzZXJAbG9jYWwiLCJpc3MiOiJURCIsImF1ZCI6Imh0dHBzOi8vd3d3LnRlYW1keW5hbWl4LmNvbS8iLCJleHAiOjE0NTgwNDg2NTEsIm5iZiI6MTQ1Nzk2MjI1MX0.DYFzy8Q9Nn0sR7fY-28vY8GHhRTn1aFe36BHy9u_J2w'
    $attachment1 = '{"ID":"e7098add-c04d-412c-a697-97ca2990c207","AttachmentType":9,"ItemID":1490430,"CreatedUid":"e7098add-c04d-412c-a697-97ca2990c207","CreatedFullName":"John Doe","CreatedDate":"2016-04-15T14:35:38.313Z","Name":"awesomefile.txt","Size":33944,"Uri":"api/attachments/e7098add-c04d-412c-a697-97ca2990c207","ContentUri":"api/attachments/e7098add-c04d-412c-a697-97ca2990c207/content"}'

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

    Describe 'Remove-TdpscAttachment' {
        Mock Get-InternalBearer -ModuleName teamdynamix-psclient {
            Write-Debug -Message 'Get-InternalBearer'

            $bearer
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Get' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'attachments/e7098add-c04d-412c-a697-97ca2990c207')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{Content = $attachment1}
        }

        Context 'Examples' {
            It 'Accepts by -ID' {
                $ID  = 'e7098add-c04d-412c-a697-97ca2990c207'
                $tmp = Get-TdpscAttachment -ID $ID

                $tmp.ID | Should Be $ID
            }
        }
    }

    Describe 'Remove-TdpscAttachment' {
        Mock Get-InternalBearer -ModuleName teamdynamix-psclient {
            Write-Debug -Message 'Get-InternalBearer'

            $bearer
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Delete' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'attachments/e7098add-c04d-412c-a697-97ca2990c207')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{StatusDescription = 'OK'}
        }

        Context 'Examples' {
            It 'Accepts by -ID' {
                $ID  = 'e7098add-c04d-412c-a697-97ca2990c207'
                $tmp = Remove-TdpscAttachment -ID $ID

                $tmp | Should Be 'OK'
            }
        }
    }
}

Remove-Module -Name teamdynamix-psclient
