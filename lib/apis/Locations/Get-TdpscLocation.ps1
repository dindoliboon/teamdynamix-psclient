#Requires -Version 3

Set-StrictMode -Version 3

function Get-TdpscLocation
{
    <#
    .SYNOPSIS
        Gets a list of all active locations.
    .DESCRIPTION
        Use Get-TdpscLocation to return a list of all active locations. The associated rooms and item counts for each location will not be retrieved.

        Invocations of this method are rate-limited, with a restriction of 60 calls per IP every 60 seconds.
    .PARAMETER Bearer
        Bearer token received when logging in.
    .PARAMETER ID
        The location ID.
    .PARAMETER NameLike
        The search text to filter on.
    .PARAMETER IsActive
        The active status to filter on.
    .PARAMETER IsRoomRequired
        The "room required" status to filter on.
    .PARAMETER RoomID
        The room ID to filter on, if any. If this value is set, only the location that contains this room will be returned.
    .PARAMETER ReturnItemCounts
        A value indicating whether asset and ticket counts should be returned for each location.
    .PARAMETER ReturnRooms
        A value indicating whether rooms should be returned for each location.
    .PARAMETER MaxResults
        The maximum number of records to return.
    .EXAMPLE
        Get-TdpscLocation

        Returns a list of all active locations.
    .EXAMPLE
        Get-TdpscLocation -ID 10

        Returns a single location.
    .EXAMPLE
        Get-TdpscLocation -NameLike 'Avenue'

        Returns all locations that contain the specified Name.
    .INPUTS
        None
        You cannot pipe objects to this cmdlet.
    .OUTPUTS
        None or TeamDynamix.Api.Locations.Location or Object[] or PSCustomObject
        Get-TdpscGroupSearch returns a TeamDynamix.Api.Locations.Location or Object[] or PSCustomObject object containing the locations. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/Locations#GETapi/locations
    #>

    [CmdletBinding(DefaultParameterSetName='Default')]
    [OutputType([Object[]], [TeamDynamix.Api.Locations.Location[]])]
    Param
    (
        [Parameter(ParameterSetName='Default')]
		[String]$Bearer,

        [Parameter(ParameterSetName='Default')]
        [System.Nullable[Int32]]$ID,

        [Parameter(ParameterSetName='BySearch')]
        [String]$NameLike,

        [Parameter(ParameterSetName='BySearch')]
        [System.Nullable[Boolean]]$IsActive,

        [Parameter(ParameterSetName='BySearch')]
        [System.Nullable[Boolean]]$IsRoomRequired,

        [Parameter(ParameterSetName='BySearch')]
        [System.Nullable[Int32]]$RoomID,

        [Parameter(ParameterSetName='BySearch')]
        [Boolean]$ReturnItemCounts,

        [Parameter(ParameterSetName='BySearch')]
        [Boolean]$ReturnRooms,

        [Parameter(ParameterSetName='BySearch')]
        [System.Nullable[Int32]]$MaxResults
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

        if ([String]::IsNullOrWhiteSpace($Bearer)) { $Bearer = Get-InternalBearer }

        if ($PSCmdlet.ParameterSetName -eq 'BySearch')
        {
            $locationSearch = New-Object -TypeName TeamDynamix.Api.Locations.LocationSearch
            $locationSearch.NameLike = $NameLike
            $locationSearch.IsActive = $IsActive
            $locationSearch.IsRoomRequired = $IsRoomRequired
            $locationSearch.RoomID = $RoomID
            $locationSearch.ReturnItemCounts = $ReturnItemCounts
            $locationSearch.ReturnRooms = $ReturnRooms
            $locationSearch.MaxResults = $MaxResults

            $parms = @{
                Body            = ConvertTo-JsonSerializeObject -InputObject $locationSearch
                ContentType     = 'application/json'
                Headers         = @{
                                        Authorization = 'Bearer ' + $Bearer
                                    }
                Method          = 'Post'
                Uri             = (Get-TdpscApiBaseAddress) + 'locations/search'
                UseBasicParsing = $true
            }
        }
        else
        {
            $parms = @{
                ContentType     = 'application/json'
                Headers         = @{
                                        Authorization = 'Bearer ' + $Bearer
                                    }
                Method          = 'Get'
                Uri             = (Get-TdpscApiBaseAddress) + 'locations{0}' -f ("/$ID", '')[[string]::IsNullOrEmpty($ID)]
                UseBasicParsing = $true
            }
        }

        Write-Debug -Message ($parms | Out-String)

        $request = Invoke-WebRequest @parms

        if ((Get-TdReturnApiType) -eq $true)
        {
            ConvertTo-JsonDeserializeObject -String $request.Content -Type ([TeamDynamix.Api.Locations.Location], [TeamDynamix.Api.Locations.Location[]])[[string]::IsNullOrEmpty($Id)]
        }
        else
        {
            $request.Content | ConvertFrom-Json
        }
    }
    End
    {
        Write-Debug -Message "[$($MyInvocation.MyCommand.Name)] complete"
    }
}
