#Requires -Version 3

Set-StrictMode -Version 3

function New-TdpscLocationRoom
{
    <#
    .SYNOPSIS
        Creates a room in a location.
    .DESCRIPTION
        Use New-TdpscLocationRoom to create a new room in a location.

        This action requires the "All: Create and modify the list of locations and their rooms" permission.

        Invocations of this method are rate-limited, with a restriction of 60 calls per IP every 60 seconds.
    .PARAMETER Bearer
        Bearer token received when logging in.
    .PARAMETER ID
        The containing location ID.
    .PARAMETER Name
        The name.
    .PARAMETER ExternalID
        The external identifier for the room.

        This is intended to allow organizations to specify an alternate identifier for the room, such as an internal code for a room.
    .EXAMPLE
        New-TdpscLocationRoom -ID 10 -Name 'Room 1'

        Returns the newly created room.
    .EXAMPLE
        Get-TdpscLocation -ID 10 | New-TdpscLocationRoom -Name 'Room 2'

        Pipes a location object, returns the newly created room.
    .INPUTS
        PSObject or TeamDynamix.Api.Locations.Location
        You can pipe a PSObject or TeamDynamix.Api.Locations.Location object that contains the information of the current location.
    .OUTPUTS
        None or TeamDynamix.Api.Locations.LocationRoom or PSCustomObject
        New-TdpscLocationRoom returns the created room if the operation was successful. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/Locations#POSTapi/locations/{id}/rooms
    #>

    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([PSObject], [TeamDynamix.Api.Locations.LocationRoom])]
    Param
    (
		[String]$Bearer,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
		[Int32]$ID,

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

        if ($PSCmdlet.ShouldProcess("Room Location Name $($Name)", 'Create Room Location'))
        {
            if ([String]::IsNullOrWhiteSpace($Bearer)) { $Bearer = Get-InternalBearer }

            $newLocation            = New-Object -TypeName TeamDynamix.Api.Locations.LocationRoom
            $newLocation.Name       = ($newLocation.Name,             $Name)[$PSBoundParameters.ContainsKey('Name')]
            $newLocation.ExternalID = ($newLocation.ExternalID, $ExternalID)[$PSBoundParameters.ContainsKey('ExternalID')]

            $parms = @{
                Body            = ConvertTo-JsonSerializeObject -InputObject $newLocation
                ContentType     = 'application/json'
                Headers         = @{
                                        Authorization = 'Bearer ' + $Bearer
                                    }
                Method          = 'Post'
                Uri             = (Get-TdpscApiBaseAddress) + "locations/$($ID)/rooms"
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
    End
    {
        Write-Debug -Message "[$($MyInvocation.MyCommand.Name)] complete"
    }
}
