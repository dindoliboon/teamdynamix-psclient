#Requires -Version 3

Set-StrictMode -Version 3

function Remove-TdpscAttachment
{
    <#
    .SYNOPSIS
        Deletes an attachment.
    .DESCRIPTION
        Use Remove-TdpscAttachment to remove an attachment.

        Invocations of this method are rate-limited, with a restriction of 60 calls per IP every 60 seconds.
    .PARAMETER Bearer
        Bearer token received when logging in.
    .PARAMETER ID
        The attachment ID.
    .EXAMPLE
        Remove-TdpscAttachment -ID '6CA4115F-0C50-4849-91FA-895CB659F36F'

        Removes the specified attachment.
    .INPUTS
        None
        You cannot pipe objects to this cmdlet.
    .OUTPUTS
        None or String
        Remove-TdpscAttachment returns a response message indicating if the operation was successful (OK) or not. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/Attachments#DELETEapi/attachments/{id}
    #>

    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([String])]
    Param
    (
		[String]$Bearer,

        [Parameter(Mandatory=$true)]
        [Guid]$ID
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

        if ($PSCmdlet.ShouldProcess("Attachment ID $($ID)", 'Remove Attachment'))
        {
            if ([String]::IsNullOrWhiteSpace($Bearer)) { $Bearer = Get-InternalBearer }

            $parms = @{
                ContentType     = 'application/json'
                Headers         = @{
                                        Authorization = 'Bearer ' + $Bearer
                                    }
                Method          = 'Delete'
                Uri             = (Get-TdpscApiBaseAddress) + "attachments/$($ID)"
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
