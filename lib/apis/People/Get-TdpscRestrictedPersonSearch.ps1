#Requires -Version 3

Set-StrictMode -Version 3

function Get-TdpscRestrictedPersonSearch
{
    <#
    .SYNOPSIS
        Performs a restricted lookup of TeamDynamix people.
    .DESCRIPTION
        Use Get-TdpscRestrictedPersonSearch to return a filtered set of TeamDynamix people.

        Will not return full user information for each matching user.

        Invocations of this method are rate-limited, with a restriction of 10 calls per IP every 1 second.
    .PARAMETER Bearer
        Bearer token received when logging in.
    .PARAMETER SearchText
        The searching text to use.
    .PARAMETER MaxResults
        The maximum number of results to return. Must be in the range 1-100, and will default to 50.
    .EXAMPLE
        Get-TdpscRestrictedPersonSearch -Bearer $Bearer -SearchText 'John Doe'

        Returns users matching search criteria.
    .INPUTS
        String
        You can pipe a String that contains a bearer token.
    .OUTPUTS
        None or PSObject or TeamDynamix.Api.Users.User or System.Object[]
        Get-TdpscRestrictedPersonSearch returns a System.Object[] object if users are found. If Get-TdReturnApiType is true and only one user is found, the type is TeamDynamix.Api.Users.User. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/People#GETapi/people/lookup?searchText={searchText}&maxResults={maxResults}
    #>

    [CmdletBinding()]
    [OutputType([PSObject])]
    Param
    (
        [Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
		[String]$Bearer,

		[String]$SearchText,

		[Int32]$MaxResults = 50
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

        $queryParms = @{
            searchText = $SearchText
            maxResults = $MaxResults
        }

        $query = ($queryParms.GetEnumerator() | Where-Object {
                [string]::IsNullOrEmpty($_.Value) -eq $false
            } | ForEach-Object {
                $_.Key + '=' + [System.Uri]::EscapeDataString($_.Value)
            }) -join '&'


        $parms = @{
            ContentType     = 'application/json'
            Headers         = @{
                                    Authorization = 'Bearer ' + $Bearer
                                }
            Method          = 'Get'
            Uri             = (Get-TdpscApiBaseAddress) + 'people/lookup{0}' -f ("?$query", '')[[string]::IsNullOrEmpty($query)]
            UseBasicParsing = $true
        }

        Write-Debug -Message ($parms | Out-String)

        $request = Invoke-WebRequest @parms

        if ((Get-TdReturnApiType) -eq $true)
        {
            ConvertTo-JsonDeserializeObject -String $request.Content -Type TeamDynamix.Api.Users.User[]
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
