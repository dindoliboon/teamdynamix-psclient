#Requires -Version 3

Set-StrictMode -Version 3

function Set-TdpscPersonGroup
{
    <#
    .SYNOPSIS
        Adds the user to group.
    .DESCRIPTION
        Use Set-TdpscPersonGroup to add the user to the group if they are not already in that group. If they are in that group, this will update whether or not that group is the user's primary group, whether they are notified along with the group, and if they are the manager of the group.

        This action can only be performed by administrative accounts and not standard TeamDynamix users.

        Invocations of this method are rate-limited, with a restriction of 180 calls per IP every 60 seconds.
    .PARAMETER Bearer
        Bearer token received when logging in.
    .PARAMETER UID
        The user unique identifier.
    .PARAMETER GroupID
        The ID of the group to add. Must match up with a pre-existing group.
    .PARAMETER IsPrimary
        Whether or not this is the user's primary group. If set to true, this will clear out any existing primary group.
    .PARAMETER IsNotified
        Whether or not this user is notified along with this group.
    .PARAMETER IsManager
        Whether or not this user is a group manager.
    .EXAMPLE
        Set-TdpscPersonGroup -UID '313f362a-b885-4ea9-996a-6cc9c9eb039b' -GroupID 3863 -IsPrimary $true

        Adds the group ID, set this role as the user's primary group.
    .EXAMPLE
        Get-TdpscPerson -UID '313f362a-b885-4ea9-996a-6cc9c9eb039b' | Set-TdpscPersonGroup -GroupID 3862

        Get UID by pipeline, adds the group ID, set as non-primary group.
    .INPUTS
        PSObject or TeamDynamix.Api.Users.User
        You can pipe a PSObject or TeamDynamix.Api.Users.User object that contains the user's UID.
    .OUTPUTS
        None or String
        Set-TdpscPersonGroup returns a response message indicating if the operation was successful (OK) or not. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/People#PUTapi/people/{uid}/groups/{groupID}?isPrimary={isPrimary}&isNotified={isNotified}&isManager={isManager}
    #>

    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([TeamDynamix.Api.Roles.UserFunctionalRole], [System.Object[]])]
    Param
    (
        [String]$Bearer,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Guid]$UID,

        [Parameter(Mandatory=$true)]
		[Int32]$GroupID,

        [Parameter()]
		[Boolean]$IsPrimary = $false,

        [Parameter()]
		[Boolean]$IsNotified = $false,

        [Parameter()]
		[Boolean]$IsManager = $false
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

        if ($PSCmdlet.ShouldProcess("User ID: $($UID), Group ID: $($GroupID)", 'Add User To Group'))
        {
            if ([String]::IsNullOrWhiteSpace($Bearer)) { $Bearer = Get-InternalBearer }

            $parms = @{
                ContentType     = 'application/json'
                Headers         = @{
                                        Authorization = 'Bearer ' + $Bearer
                                    }
                Method          = 'Put'
                Uri             = (Get-TdpscApiBaseAddress) + "people/$($UID)/groups/$($GroupID)?isPrimary=$($IsPrimary)&isNotified=$($IsNotified)&isManager=$($IsManager)"
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
