#Requires -Version 3

Set-StrictMode -Version 3

function Remove-TdpscPersonGroup
{
    <#
    .SYNOPSIS
        Removes the user from a group.
    .DESCRIPTION
        Use Remove-TdpscPersonGroup to removes the user from a group.

        This action can only be performed by administrative accounts and not standard TeamDynamix users.

        Invocations of this method are rate-limited, with a restriction of 180 calls per IP every 60 seconds.
    .PARAMETER Bearer
        Bearer token received when logging in.
    .PARAMETER UID
        The user unique identifier.
    .PARAMETER GroupID
        The group ID.
    .EXAMPLE
        Remove-TdpscPersonGroup -UID '313f362a-b885-4ea9-996a-6cc9c9eb039b' -GroupID 12

        Remove the user from the specified group.
    .INPUTS
        None
        You cannot pipe objects to this cmdlet.
    .OUTPUTS
        None or String
        Remove-TdpscPersonGroup returns a response message indicating if the operation was successful (OK) or not. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/People#DELETEapi/people/{uid}/groups/{groupID}
    #>

    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([String])]
    Param
    (
        [String]$Bearer,

        [Parameter(Mandatory=$true)]
		[Guid]$UID,

        [Parameter(Mandatory=$true)]
		[Int32]$GroupID
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

        if ($PSCmdlet.ShouldProcess("Group ID $($GroupID) from UID $($UID)", 'Remove User From Group'))
        {
            if ([String]::IsNullOrWhiteSpace($Bearer)) { $Bearer = Get-InternalBearer }

            $parms = @{
                ContentType     = 'application/json'
                Headers         = @{
                                        Authorization = 'Bearer ' + $Bearer
                                    }
                Method          = 'Delete'
                Uri             = (Get-TdpscApiBaseAddress) + "people/$($UID)/groups/$($GroupID)"
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
