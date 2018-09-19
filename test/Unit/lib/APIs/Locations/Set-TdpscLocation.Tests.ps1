#Requires -Version 3

Set-StrictMode -Version 3

#Continue
#SilentlyContinue
$Script:DebugPreference   = 'SilentlyContinue'
$Script:VerbosePreference = 'SilentlyContinue'

Import-Module -Name "$PSScriptRoot\..\..\..\..\..\teamdynamix-psclient"

InModuleScope teamdynamix-psclient {
    $bearer       = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1bmlxdWVfbmFtZSI6InVzZXJAbG9jYWwiLCJpc3MiOiJURCIsImF1ZCI6Imh0dHBzOi8vd3d3LnRlYW1keW5hbWl4LmNvbS8iLCJleHAiOjE0NTgwNDg2NTEsIm5iZiI6MTQ1Nzk2MjI1MX0.DYFzy8Q9Nn0sR7fY-28vY8GHhRTn1aFe36BHy9u_J2w'
    $location1    = '{"ID":4032,"Name":"Building 2","Description":"The second building","ExternalID":"","IsActive":false,"Address":"","City":"","State":"  ","PostalCode":"          ","Country":"","IsRoomRequired":false,"AssetsCount":0,"TicketsCount":0,"RoomsCount":1,"Rooms":[{"ID":104829,"Name":"Room 13 edit","ExternalID":"","AssetsCount":0,"TicketsCount":0,"CreatedDate":"2016-04-19T13:30:44.583Z","CreatedUID":"9e689d73-0000-0000-0000-0010188dda92","CreatedFullName":"API User"}],"CreatedDate":"2016-04-15T20:30:45.31Z","CreatedUid":"9e689d73-0000-0000-0000-0010188dda92","CreatedFullName":"John Doe","ModifiedDate":"2016-04-19T13:05:04.71Z","ModifiedUid":"9e689d73-0000-0000-0000-0010188dda92","ModifiedFullName":"John Doe"}'
    $location2    = '{"ID":4033,"Name":"Building 2","Description":"The second building","ExternalID":"","IsActive":false,"Address":"","City":"","State":"  ","PostalCode":"          ","Country":"","IsRoomRequired":false,"AssetsCount":0,"TicketsCount":0,"RoomsCount":1,"Rooms":[{"ID":104830,"Name":"Room 13 edit","ExternalID":"","AssetsCount":0,"TicketsCount":0,"CreatedDate":"2016-04-19T13:30:44.583Z","CreatedUID":"9e689d73-0000-0000-0000-0010188dda92","CreatedFullName":"API User"}],"CreatedDate":"2016-04-15T20:30:45.31Z","CreatedUid":"9e689d73-0000-0000-0000-0010188dda92","CreatedFullName":"John Doe","ModifiedDate":"2016-04-19T13:05:04.71Z","ModifiedUid":"9e689d73-0000-0000-0000-0010188dda92","ModifiedFullName":"John Doe"}'

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

    Describe 'Set-TdpscLocation' {
        Mock Get-InternalBearer -ModuleName teamdynamix-psclient {
            Write-Debug -Message 'Get-InternalBearer'

            $bearer
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Get' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'locations/4032')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{Content = $location1}
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Get' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'locations/4033')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{Content = $location2}
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Put' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'locations/4032') -and $Body -eq '{"ID":4032,"Name":"Building 1","Description":"The first building","ExternalID":"","IsActive":false,"Address":"","City":"","State":"  ","PostalCode":"          ","Country":"","IsRoomRequired":false,"AssetsCount":0,"TicketsCount":0,"RoomsCount":1,"Rooms":[{"ID":104829,"Name":"Room 13 edit","ExternalID":"","AssetsCount":0,"TicketsCount":0,"CreatedDate":"2016-04-19T13:30:44.583Z","CreatedUID":"9e689d73-0000-0000-0000-0010188dda92","CreatedFullName":"API User"}],"CreatedDate":"2016-04-15T20:30:45.31Z","CreatedUid":"9e689d73-0000-0000-0000-0010188dda92","CreatedFullName":"John Doe","ModifiedDate":"2016-04-19T13:05:04.71Z","ModifiedUid":"9e689d73-0000-0000-0000-0010188dda92","ModifiedFullName":"John Doe"}'} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{Content = $Body}
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Put' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'locations/4033') -and $Body -eq '{"ID":4033,"Name":"Building 2","Description":"The second building","ExternalID":"","IsActive":false,"Address":"","City":"","State":"  ","PostalCode":"          ","Country":"","IsRoomRequired":false,"AssetsCount":0,"TicketsCount":0,"RoomsCount":1,"Rooms":[{"ID":104830,"Name":"Room 13 edit","ExternalID":"","AssetsCount":0,"TicketsCount":0,"CreatedDate":"\/Date(1461072644583)\/","CreatedUID":"9e689d73-0000-0000-0000-0010188dda92","CreatedFullName":"API User"}],"CreatedDate":"\/Date(1460752245310)\/","CreatedUid":"9e689d73-0000-0000-0000-0010188dda92","CreatedFullName":"John Doe","ModifiedDate":"\/Date(1461071104710)\/","ModifiedUid":"9e689d73-0000-0000-0000-0010188dda92","ModifiedFullName":"John Doe","Latitude":null,"Longitude":null}'} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{Content = $Body}
        }

        Context 'Examples' {
            It 'Accepts with -ID, -Name, and -Description' {
                $tmp = Set-TdpscLocation -ID 4032 -Name 'Building 1' -Description 'The first building'

                $tmp.Name | Should Be 'Building 1'
            }

            It 'Accepts with -Name and -Description and -ID via pipeline' {
                $tmp = Get-TdpscLocation -ID 4033 | Set-TdpscLocation -Name 'Building 2' -Description 'The second building'

                $tmp.Name | Should Be 'Building 2'
            }
        }
    }
}

Remove-Module -Name teamdynamix-psclient
