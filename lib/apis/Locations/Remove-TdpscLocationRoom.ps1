#Requires -Version 3

Set-StrictMode -Version 3

function Remove-TdpscLocationRoom
{
    <#
    .SYNOPSIS
        Deletes a room in a location.
    .DESCRIPTION
        Use Remove-TdpscLocationRoom to deletes a room in a location.

        This action requires the "All: Create and modify the list of locations and their rooms" permission.

        Invocations of this method are rate-limited, with a restriction of 60 calls per IP every 60 seconds.
    .PARAMETER Bearer
        Bearer token received when logging in.
    .PARAMETER ID
        The containing location ID.
    .PARAMETER RoomId
        The room ID.
    .EXAMPLE
        Remove-TdpscLocationRoom -ID 10 -RoomId 5

        Deletes the specified room.
    .EXAMPLE
        Get-TdpscLocation -ID 10 | Remove-TdpscLocationRoom -RoomId 6

        Pipes a location object, deletes the specified room.
    .INPUTS
        PSObject or TeamDynamix.Api.Locations.Location
        You can pipe a PSObject or TeamDynamix.Api.Locations.Location object that contains the information of the current location.
    .OUTPUTS
        None or String
        A response message indicating if the operation was successful (OK) or not.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/Locations#DELETEapi/locations/{id}/rooms/{roomId}
    #>

    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([PSObject], [TeamDynamix.Api.Locations.LocationRoom])]
    Param
    (
		[String]$Bearer,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
		[Int32]$ID,

        [Parameter(Mandatory=$true)]
		[Int32]$RoomId
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

        if ($PSCmdlet.ShouldProcess("Room Location ID $($RoomId)", 'Delete Room Location'))
        {
            if ([String]::IsNullOrWhiteSpace($Bearer)) { $Bearer = Get-InternalBearer }

            $parms = @{
                ContentType     = 'application/json'
                Headers         = @{
                                        Authorization = 'Bearer ' + $Bearer
                                    }
                Method          = 'Delete'
                Uri             = (Get-TdpscApiBaseAddress) + "locations/$($ID)/rooms/$($RoomId)"
                UseBasicParsing = $true
            }

            Write-Debug -Message ($parms | Out-String)

            $request = Invoke-WebRequest @parms

            $request.StatusDescription
        }
    }
    End
    {
        Write-Debug -Message "[$($MyInvocation.MyCommand.Name)] complete"
    }
}
