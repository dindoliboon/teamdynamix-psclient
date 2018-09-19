#Requires -Version 3

Set-StrictMode -Version 3

function Get-TdpscPersonSearch
{
    <#
    .SYNOPSIS
        Gets a list of users.
    .DESCRIPTION
        Use Get-TdpscPersonSearch to return a collection of users.

        Does not return collection objects such as Applications, Permissions, Groups, or Custom Attributes. Use the singular GET to retrieve these collections for a singular user.

        This action requires access to the TDPeople application.

        Invocations of this method are rate-limited, with a restriction of 60 calls per IP every 60 seconds.

        If you are attempting to look up basic user information using a simple search string, consider using the Get-TdpscRestrictedPersonSearch method instead.
    .PARAMETER Bearer
        Bearer token received when logging in.
    .PARAMETER SearchText
        The search text to perform LIKE-based filtering on.
    .PARAMETER IsActive
        The active status to filter on.
    .PARAMETER IsEmployee
        The employee status to filter on.
    .PARAMETER AppName
        The name of the application to filter on. If specified, will only include users who have been granted access to this application.
    .PARAMETER AccountIDs
        The account ID to filter on. If specified, will only include users who list the account as their default.
    .PARAMETER MaxResults
        The maximum number of records to return.
    .EXAMPLE
        Get-TdpscPersonSearch -Bearer $Bearer -SearchText 'John Doe'

        Returns users matching search criteria.
    .INPUTS
        String
        You can pipe a String that contains a bearer token.
    .OUTPUTS
        None or PSObject or TeamDynamix.Api.Users.User or System.Object[]
        Get-TdpscPersonSearch returns a System.Object[] object if users are found. If Get-TdReturnApiType is true and only one user is found, the type is TeamDynamix.Api.Users.User. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/People#POSTapi/people/search
    #>

    [CmdletBinding()]
    [OutputType([TeamDynamix.Api.Users.User], [System.Object[]])]
    Param
    (
        [Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
		[String]$Bearer,

		[String]$SearchText,

		[System.Nullable[Boolean]]$IsActive = $null,

		[System.Nullable[Boolean]]$IsEmployee = $null,

		[String]$AppName,

		[Int32[]]$AccountIDs = $null,

		[System.Nullable[Int32]]$MaxResults = 25
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

        $search = New-Object -TypeName TeamDynamix.Api.Users.UserSearch
        $search.SearchText  = $SearchText
        $search.IsActive    = $IsActive
        $search.IsEmployee  = $IsEmployee
        $search.AppName     = $AppName
        $search.AccountIDs  = $AccountIDs
        $search.MaxResults  = $MaxResults

        $parms = @{
            Body            = ConvertTo-JsonSerializeObject -InputObject $search
            ContentType     = 'application/json'
            Headers         = @{
                                    Authorization = 'Bearer ' + $Bearer
                                }
            Method          = 'Post'
            Uri             = (Get-TdpscApiBaseAddress) + 'people/search'
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
