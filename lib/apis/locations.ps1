<#
    Contains methods for working with locations.

    https://app.teamdynamix.com/TDWebApi/Home/section/Locations
#>

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

function New-TdpscLocation
{
    <#
    .SYNOPSIS
        Creates a location.
    .DESCRIPTION
        Use New-TdpscLocation to create a new location.

        This action requires the "All: Create and modify the list of locations and their rooms" permission.

        Invocations of this method are rate-limited, with a restriction of 60 calls per IP every 60 seconds.
    .PARAMETER Bearer
        Bearer token received when logging in.
    .PARAMETER Name
        The name.
    .PARAMETER Description
        The description.
    .PARAMETER ExternalID
        The external identifier for the location.
    .PARAMETER IsActive
        The active status.
    .PARAMETER Address
        The address.
    .PARAMETER City
        The city.
    .PARAMETER State
        The state/province.
    .PARAMETER PostalCode
        The postal code.
    .PARAMETER Country
        The country.
    .PARAMETER IsRoomRequired
        A value indicating whether the location requires a room when specified for an asset.
    .EXAMPLE
        New-TdpscLocation -Name 'Building 1' -Description 'The first building'

        Returns the newly created location.
    .INPUTS
        PSObject or TeamDynamix.Api.Locations.Location
        You can pipe a PSObject or TeamDynamix.Api.Locations.Location object that contains the information of the new location.
    .OUTPUTS
        None or TeamDynamix.Api.Locations.Location or Object[] or PSCustomObject
        New-TdpscLocation returns the created location if the operation was successful. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/Locations#POSTapi/locations
    #>

    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([PSObject], [TeamDynamix.Api.Locations.Location])]
    Param
    (
		[String]$Bearer,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
		[String]$Name,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
		[String]$Description,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
		[String]$ExternalID,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
		[Boolean]$IsActive,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
		[String]$Address,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
		[String]$City,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
		[String]$State,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
		[String]$PostalCode,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
		[String]$Country,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
		[Boolean]$IsRoomRequired
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

        if ($PSCmdlet.ShouldProcess("Location Name $($Name)", 'Create Location'))
        {
            if ([String]::IsNullOrWhiteSpace($Bearer)) { $Bearer = Get-InternalBearer }

            if ($null -ne $_ -and ($_.GetType().FullName -eq 'TeamDynamix.Api.Locations.Location' -or $_.GetType().FullName -eq 'System.Management.Automation.PSCustomObject'))
            {
                Write-Debug -Message 'Use existing location information from pipeline'
                $parms = @{
                    'String' = ConvertTo-JsonSerializeObject -InputObject $_
                    'Type'   = [TeamDynamix.Api.Locations.Location]
                }

                $newLocation = ConvertTo-JsonDeserializeObject @parms
            }
            else
            {
                $newLocation = New-Object -TypeName TeamDynamix.Api.Locations.Location
            }

            $newLocation.Name           = ($newLocation.Name,                     $Name)[$PSBoundParameters.ContainsKey('Name')]
            $newLocation.Description    = ($newLocation.Description,       $Description)[$PSBoundParameters.ContainsKey('Description')]
            $newLocation.ExternalID     = ($newLocation.ExternalID,         $ExternalID)[$PSBoundParameters.ContainsKey('ExternalID')]
            $newLocation.IsActive       = ($newLocation.IsActive,             $IsActive)[$PSBoundParameters.ContainsKey('IsActive')]
            $newLocation.Address        = ($newLocation.Address,               $Address)[$PSBoundParameters.ContainsKey('Address')]
            $newLocation.City           = ($newLocation.City,                     $City)[$PSBoundParameters.ContainsKey('City')]
            $newLocation.State          = ($newLocation.State,                   $State)[$PSBoundParameters.ContainsKey('State')]
            $newLocation.PostalCode     = ($newLocation.PostalCode,         $PostalCode)[$PSBoundParameters.ContainsKey('PostalCode')]
            $newLocation.Country        = ($newLocation.Country,               $Country)[$PSBoundParameters.ContainsKey('Country')]
            $newLocation.IsRoomRequired = ($newLocation.IsRoomRequired, $IsRoomRequired)[$PSBoundParameters.ContainsKey('IsRoomRequired')]

            $parms = @{
                Body            = ConvertTo-JsonSerializeObject -InputObject $newLocation
                ContentType     = 'application/json'
                Headers         = @{
                                        Authorization = 'Bearer ' + $Bearer
                                    }
                Method          = 'Post'
                Uri             = (Get-TdpscApiBaseAddress) + 'locations'
                UseBasicParsing = $true
            }

            Write-Debug -Message ($parms | Out-String)

            $request = Invoke-WebRequest @parms

            if ((Get-TdReturnApiType) -eq $true)
            {
                ConvertTo-JsonDeserializeObject -String $request.Content -Type TeamDynamix.Api.Locations.Location
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

function Set-TdpscLocation
{
    <#
    .SYNOPSIS
        Edits the specified location.
    .DESCRIPTION
        Use Set-TdpscLocation to edit the specified location.

        This action requires the "All: Create and modify the list of locations and their rooms" permission.

        Invocations of this method are rate-limited, with a restriction of 60 calls per IP every 60 seconds.
    .PARAMETER Bearer
        Bearer token received when logging in.
    .PARAMETER ID
        The location ID.
    .PARAMETER Name
        The name.
    .PARAMETER Description
        The description.
    .PARAMETER ExternalID
        The external identifier for the location.
    .PARAMETER IsActive
        The active status.
    .PARAMETER Address
        The address.
    .PARAMETER City
        The city.
    .PARAMETER State
        The state/province.
    .PARAMETER PostalCode
        The postal code.
    .PARAMETER Country
        The country.
    .PARAMETER IsRoomRequired
        A value indicating whether the location requires a room when specified for an asset.
    .EXAMPLE
        Set-TdpscLocation -ID 4579 -Name 'Building 1' -Description 'The first building'

        Returns the updated location.
    .EXAMPLE
        Get-TdpscLocation -ID 4579 | Set-TdpscLocation -Name 'Building 2' -Description 'The second building'

        Returns the updated location.
    .INPUTS
        PSObject or TeamDynamix.Api.Locations.Location
        You can pipe a PSObject or TeamDynamix.Api.Locations.Location object that contains the information of the new location.
    .OUTPUTS
        None or TeamDynamix.Api.Locations.Location or PSCustomObject
        New-TdpscLocation returns the updated location if the operation was successful. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/Locations#PUTapi/locations/{id}
    #>

    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([PSObject], [TeamDynamix.Api.Locations.Location])]
    Param
    (
		[String]$Bearer,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
		[Int32]$ID,

		[String]$Name,

		[String]$Description,

		[String]$ExternalID,

		[Boolean]$IsActive,

		[String]$Address,

		[String]$City,

		[String]$State,

		[String]$PostalCode,

		[String]$Country,

		[Boolean]$IsRoomRequired
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

            if ($null -ne $_ -and ($_.GetType().FullName -eq 'TeamDynamix.Api.Locations.Location' -or $_.GetType().FullName -eq 'System.Management.Automation.PSCustomObject'))
            {
                Write-Debug -Message 'Use existing location information from pipeline'
                $parms = @{
                    'String' = ConvertTo-JsonSerializeObject -InputObject $_
                    'Type'   = [TeamDynamix.Api.Locations.Location]
                }

                $locationModify = ConvertTo-JsonDeserializeObject @parms
            }
            else
            {
                $locationModify = Get-TdpscLocation -ID $ID
            }

            $locationModify.Name           = ($locationModify.Name,                     $Name)[$PSBoundParameters.ContainsKey('Name')]
            $locationModify.Description    = ($locationModify.Description,       $Description)[$PSBoundParameters.ContainsKey('Description')]
            $locationModify.ExternalID     = ($locationModify.ExternalID,         $ExternalID)[$PSBoundParameters.ContainsKey('ExternalID')]
            $locationModify.IsActive       = ($locationModify.IsActive,             $IsActive)[$PSBoundParameters.ContainsKey('IsActive')]
            $locationModify.Address        = ($locationModify.Address,               $Address)[$PSBoundParameters.ContainsKey('Address')]
            $locationModify.City           = ($locationModify.City,                     $City)[$PSBoundParameters.ContainsKey('City')]
            $locationModify.State          = ($locationModify.State,                   $State)[$PSBoundParameters.ContainsKey('State')]
            $locationModify.PostalCode     = ($locationModify.PostalCode,         $PostalCode)[$PSBoundParameters.ContainsKey('PostalCode')]
            $locationModify.Country        = ($locationModify.Country,               $Country)[$PSBoundParameters.ContainsKey('Country')]
            $locationModify.IsRoomRequired = ($locationModify.IsRoomRequired, $IsRoomRequired)[$PSBoundParameters.ContainsKey('IsRoomRequired')]

            $parms = @{
                Body            = ConvertTo-JsonSerializeObject -InputObject $locationModify
                ContentType     = 'application/json'
                Headers         = @{
                                        Authorization = 'Bearer ' + $Bearer
                                    }
                Method          = 'Put'
                Uri             = (Get-TdpscApiBaseAddress) + "locations/$($ID)"
                UseBasicParsing = $true
            }

            Write-Debug -Message ($parms | Out-String)

            $request = Invoke-WebRequest @parms

            if ((Get-TdReturnApiType) -eq $true)
            {
                ConvertTo-JsonDeserializeObject -String $request.Content -Type TeamDynamix.Api.Locations.Location
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

Export-ModuleMember -Function Get-TdpscLocation
Export-ModuleMember -Function New-TdpscLocation
Export-ModuleMember -Function New-TdpscLocationRoom
Export-ModuleMember -Function Remove-TdpscLocationRoom
Export-ModuleMember -Function Set-TdpscLocation
Export-ModuleMember -Function Set-TdpscLocationRoom
