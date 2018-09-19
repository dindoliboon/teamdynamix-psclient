#Requires -Version 3

Set-StrictMode -Version 3

function Set-TdpscPersonFunctionalRole
{
    <#
    .SYNOPSIS
        Adds the user to functional role.
    .DESCRIPTION
        Use Set-TdpscPersonFunctionalRole to add the user to the functional role if they are not already in that role. If they are in that role, this will update whether or not that role is the user's primary functional role.

        This action can only be performed by administrative accounts and not standard TeamDynamix users.

        Invocations of this method are rate-limited, with a restriction of 180 calls per IP every 60 seconds.
    .PARAMETER Bearer
        Bearer token received when logging in.
    .PARAMETER UID
        The user unique identifier.
    .PARAMETER RoleID
        The functional role ID.
    .PARAMETER IsPrimary
        Indicates whether or not to set this role as the user's primary functional role.
    .EXAMPLE
        Set-TdpscPersonFunctionalRole -UID '313f362a-b885-4ea9-996a-6cc9c9eb039b' -RoleID 6586 -IsPrimary $true

        Adds the role ID, set this role as the user's primary functional role.
    .EXAMPLE
        Get-TdpscPerson -UID '313f362a-b885-4ea9-996a-6cc9c9eb039b' | Set-TdpscPersonFunctionalRole -RoleID 6586

        Get UID by pipeline, adds the role ID, set as non-primary functional role.
    .INPUTS
        PSObject or TeamDynamix.Api.Users.User
        You can pipe a PSObject or TeamDynamix.Api.Users.User object that contains the user's UID.
    .OUTPUTS
        None or String
        Set-TdpscPersonFunctionalRole returns a response message indicating if the operation was successful (OK) or not. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/People#PUTapi/people/{uid}/functionalroles/{roleId}?isPrimary={isPrimary}
    #>

    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([TeamDynamix.Api.Roles.UserFunctionalRole], [System.Object[]])]
    Param
    (
        [String]$Bearer,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Guid]$UID,

        [Parameter(Mandatory=$true)]
		[Int32]$RoleID,

        [Parameter()]
		[Boolean]$IsPrimary = $false
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

        if ($PSCmdlet.ShouldProcess("User ID: $($UID), Role ID: $($RoleID)", 'Add User To Role'))
        {
            if ([String]::IsNullOrWhiteSpace($Bearer)) { $Bearer = Get-InternalBearer }

            $parms = @{
                ContentType     = 'application/json'
                Headers         = @{
                                        Authorization = 'Bearer ' + $Bearer
                                    }
                Method          = 'Put'
                Uri             = (Get-TdpscApiBaseAddress) + "people/$($UID)/functionalroles/$($RoleID)?isPrimary=$($IsPrimary)"
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
