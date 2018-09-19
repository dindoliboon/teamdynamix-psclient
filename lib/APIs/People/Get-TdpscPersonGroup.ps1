#Requires -Version 3

Set-StrictMode -Version 3

function Get-TdpscPersonGroup
{
    <#
    .SYNOPSIS
        Gets all groups for a particular user.
    .DESCRIPTION
        Use Get-TdpscPersonGroup to return all groups for the specified user.

        This action can only be performed by administrative accounts and not standard TeamDynamix users.

        Invocations of this method are rate-limited, with a restriction of 180 calls per IP every 60 seconds.
    .PARAMETER Bearer
        Bearer token received when logging in.
    .PARAMETER UID
        The user unique identifier.
    .EXAMPLE
        Get-TdpscPersonGroup -UID '313f362a-b885-4ea9-996a-6cc9c9eb039b'

        Return the groups matching the requested UID.
    .INPUTS
        String
        You can pipe a String that contains a user UID.
    .OUTPUTS
        None or TeamDynamix.Api.Users.UserGroup[] or System.Object[]
        Get-TdpscPersonGroup returns a System.Object[] object if any groups are found. If Get-TdReturnApiType is true and only one group is found, the type is TeamDynamix.Api.Users.UserGroup. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/People#GETapi/people/{uid}/groups
    #>

    [CmdletBinding()]
    [OutputType([TeamDynamix.Api.Users.UserGroup], [System.Object[]])]
    Param
    (
        [String]$Bearer,

        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
		[Guid]$UID
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

        $parms = @{
            ContentType     = 'application/json'
            Headers         = @{
                                    Authorization = 'Bearer ' + $Bearer
                                }
            Method          = 'Get'
            Uri             = (Get-TdpscApiBaseAddress) + "people/$($UID)/groups"
            UseBasicParsing = $true
        }

        Write-Debug -Message ($parms | Out-String)

        $request = Invoke-WebRequest @parms

        if ((Get-TdReturnApiType) -eq $true)
        {
            ConvertTo-JsonDeserializeObject -String $request.Content -Type TeamDynamix.Api.Roles.UserFunctionalRole[]
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
