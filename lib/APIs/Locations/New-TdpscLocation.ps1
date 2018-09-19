#Requires -Version 3

Set-StrictMode -Version 3

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
