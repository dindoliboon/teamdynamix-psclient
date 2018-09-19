#Requires -Version 3

Set-StrictMode -Version 3

#Continue
#SilentlyContinue
$Script:DebugPreference   = 'SilentlyContinue'
$Script:VerbosePreference = 'SilentlyContinue'

Import-Module -Name "$PSScriptRoot\..\..\..\..\..\teamdynamix-psclient"

InModuleScope teamdynamix-psclient {
    $bearer       = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1bmlxdWVfbmFtZSI6InVzZXJAbG9jYWwiLCJpc3MiOiJURCIsImF1ZCI6Imh0dHBzOi8vd3d3LnRlYW1keW5hbWl4LmNvbS8iLCJleHAiOjE0NTgwNDg2NTEsIm5iZiI6MTQ1Nzk2MjI1MX0.DYFzy8Q9Nn0sR7fY-28vY8GHhRTn1aFe36BHy9u_J2w'
    $location2    = '{"ID":4033,"Name":"Building 2","Description":"The second building","ExternalID":"","IsActive":false,"Address":"","City":"","State":"  ","PostalCode":"          ","Country":"","IsRoomRequired":false,"AssetsCount":0,"TicketsCount":0,"RoomsCount":1,"Rooms":[{"ID":104830,"Name":"Room 13 edit","ExternalID":"","AssetsCount":0,"TicketsCount":0,"CreatedDate":"2016-04-19T13:30:44.583Z","CreatedUID":"9e689d73-0000-0000-0000-0010188dda92","CreatedFullName":"API User"}],"CreatedDate":"2016-04-15T20:30:45.31Z","CreatedUid":"9e689d73-0000-0000-0000-0010188dda92","CreatedFullName":"John Doe","ModifiedDate":"2016-04-19T13:05:04.71Z","ModifiedUid":"9e689d73-0000-0000-0000-0010188dda92","ModifiedFullName":"John Doe"}'
    $room1        = '{"ID":104829,"Name":"Room 1","ExternalID":"","AssetsCount":0,"TicketsCount":0,"CreatedDate":"2016-04-19T12:35:08.897Z","CreatedUID":"0592e4e6-0000-0000-0000-000d3a113e84","CreatedFullName":"John Doe"}'
    $room2        = '{"ID":104830,"Name":"Room 2","ExternalID":"","AssetsCount":0,"TicketsCount":0,"CreatedDate":"2016-04-19T12:35:08.897Z","CreatedUID":"0592e4e6-0000-0000-0000-000d3a113e84","CreatedFullName":"John Doe"}'

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

    Describe 'New-TdpscLocationRoom' {
        Mock Get-InternalBearer -ModuleName teamdynamix-psclient {
            Write-Debug -Message 'Get-InternalBearer'

            $bearer
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Post' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'locations/4032/rooms') -and $Body -eq '{"ID":0,"Name":"Room 1","ExternalID":"","AssetsCount":0,"TicketsCount":0,"CreatedDate":"\/Date(-62135578800000)\/","CreatedUID":"00000000-0000-0000-0000-000000000000","CreatedFullName":null}'} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{Content = $room1}
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Post' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'locations/4033/rooms') -and $Body -eq '{"ID":0,"Name":"Room 2","ExternalID":"","AssetsCount":0,"TicketsCount":0,"CreatedDate":"\/Date(-62135578800000)\/","CreatedUID":"00000000-0000-0000-0000-000000000000","CreatedFullName":null}'} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{Content = $room2}
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Get' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'locations/4033')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{Content = $location2}
        }

        Context 'Examples' {
            It 'Accepts with -ID and -Name' {
                $tmp = New-TdpscLocationRoom -ID 4032 -Name 'Room 1'

                $tmp.Name | Should Be 'Room 1'
            }

            It 'Accepts with -Name and -ID via pipeline' {
                $tmp = Get-TdpscLocation -ID 4033 | New-TdpscLocationRoom -Name 'Room 2'

                $tmp.Name | Should Be 'Room 2'
            }
        }
    }
}

Remove-Module -Name teamdynamix-psclient
