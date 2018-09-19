#Requires -Version 3

Set-StrictMode -Version 3

function Set-TdpscLocationRoom
{
    <#
    .SYNOPSIS
        Edits the specified room in a location.
    .DESCRIPTION
        Use Set-TdpscLocationRoom to edit the specified room in a location.

        This action requires the "All: Create and modify the list of locations and their rooms" permission.

        Invocations of this method are rate-limited, with a restriction of 60 calls per IP every 60 seconds.
    .PARAMETER Bearer
        Bearer token received when logging in.
    .PARAMETER ID
        The location ID.
    .PARAMETER RoomId
        The room ID.
    .PARAMETER Name
        The name.
    .PARAMETER ExternalID
        The external identifier for the room.

        This is intended to allow organizations to specify an alternate identifier for the room, such as an internal code for a room.
    .EXAMPLE
        Set-TdpscLocationRoom -ID 4579 -RoomId 100 -Name 'Room 1'

        Returns the updated room.
    .EXAMPLE
        Get-TdpscLocation -ID 4579 | Set-TdpscLocationRoom -RoomId 100 -Name 'Room 1'

        Returns the updated room.
    .INPUTS
        PSObject or TeamDynamix.Api.Locations.Location
        You can pipe a PSObject or TeamDynamix.Api.Locations.Location object that contains the information of the location.
    .OUTPUTS
        None or TeamDynamix.Api.Locations.Location or PSCustomObject
        Set-TdpscLocationRoom returns the updated room if the operation was successful. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/Locations#PUTapi/locations/{id}/rooms/{roomId}
    #>

    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([PSObject], [TeamDynamix.Api.Locations.LocationRoom])]
    Param
    (
		[String]$Bearer,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
		[Int32]$ID,

        [Parameter(Mandatory=$true)]
		[Int32]$RoomId,

        [Parameter(Mandatory=$true)]
		[String]$Name,

		[String]$ExternalID
    )

    Begin
    {
        Write-Debug -Message "[$($MyInvocation.MyCommand.Name)] start"
        Write-Debug -Message "ParameterSetName = $($PSCmdlet.ParameterSetName)"
        Write-Debug -Message "Called from $($stack = Get-PSCallStack; $stack[1].Command) at $($stack[1].Location)"
    }
    Process
    {
        Write-Debug -Message 'Process being called'

        if ($PSCmdlet.ShouldProcess("Location ID $($ID)", 'Update Location'))
        {
            if ([String]::IsNullOrWhiteSpace($Bearer)) { $Bearer = Get-InternalBearer }

            $roomModify = (Get-TdpscLocation -ID $ID).Rooms | Where-Object {$_.ID -eq $RoomId}

            if ($null -ne $roomModify)
            {
                $roomModify.Name       = ($roomModify.Name,             $Name)[$PSBoundParameters.ContainsKey('Name')]
                $roomModify.ExternalID = ($roomModify.ExternalID, $ExternalID)[$PSBoundParameters.ContainsKey('ExternalID')]

                $parms = @{
                    Body            = ConvertTo-JsonSerializeObject -InputObject $roomModify
                    ContentType     = 'application/json'
                    Headers         = @{
                                            Authorization = 'Bearer ' + $Bearer
                                        }
                    Method          = 'Put'
                    Uri             = (Get-TdpscApiBaseAddress) + "locations/$($ID)/rooms/$($RoomId)"
                    UseBasicParsing = $true
                }

                Write-Debug -Message ($parms | Out-String)

                $request = Invoke-WebRequest @parms

                if ((Get-TdReturnApiType) -eq $true)
                {
                    ConvertTo-JsonDeserializeObject -String $request.Content -Type TeamDynamix.Api.Locations.LocationRoom
                }
                else
                {
                    $request.Content | ConvertFrom-Json
                }
            }
        }
    }
    End
    {
        Write-Debug -Message "[$($MyInvocation.MyCommand.Name)] complete"
    }
}
