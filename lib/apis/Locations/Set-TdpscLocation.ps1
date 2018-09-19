#Requires -Version 3

Set-StrictMode -Version 3

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
