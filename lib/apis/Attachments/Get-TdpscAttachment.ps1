#Requires -Version 3

Set-StrictMode -Version 3

function Get-TdpscAttachment
{
    <#
    .SYNOPSIS
        Gets an attachment.
    .DESCRIPTION
        Use Get-TdpscAttachment to return information about an attachment or to save the contents of an attachment.

        Invocations of this method are rate-limited, with a restriction of 60 calls per IP every 60 seconds.
    .PARAMETER Bearer
        Bearer token received when logging in.
    .PARAMETER ID
        The attachment ID.
    .PARAMETER Content
        Specifies retrieval of the contents of the attachment.
    .PARAMETER FilePath
        Specifies location to save the contents of the attachment.
    .EXAMPLE
        Get-TdpscAttachment -ID '6CA4115F-0C50-4849-91FA-895CB659F36F'

        Returns information about the attachment.
    .EXAMPLE
        Get-TdpscAttachment -ID '6CA4115F-0C50-4849-91FA-895CB659F36F' -Content

        Returns the contents of the attachment.
    .EXAMPLE
        Get-TdpscAttachment -ID '6CA4115F-0C50-4849-91FA-895CB659F36F' -FilePath 'V:\myfile.txt' -Force

        Saves the contents of the attachment to the specified FilePath. If the target file already exists, it is overwritten.
    .INPUTS
        None
        You cannot pipe objects to this cmdlet.
    .OUTPUTS
        None or PSObject or TeamDynamix.Api.Attachments.Attachment or Object[]
        Get-TdpscAttachment returns a PSObject or TeamDynamix.Api.Attachments.Attachment object containing information about the attachment. If the Content parameter is used, it returns the contents of the attachment as an Object[]. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/Attachments#GETapi/attachments/{id}
        https://app.teamdynamix.com/TDWebApi/Home/section/Attachments#GETapi/attachments/{id}/content
    #>

    [CmdletBinding(DefaultParameterSetName='ID')]
    [OutputType([Object[]], [PSObject], [TeamDynamix.Api.Attachments.Attachment])]
    Param
    (
        [Parameter(ParameterSetName='Content')]
        [Parameter(ParameterSetName='FilePath')]
        [Parameter(ParameterSetName='ID')]
		[String]$Bearer,

        [Parameter(Mandatory=$true, ParameterSetName='Content')]
        [Parameter(Mandatory=$true, ParameterSetName='FilePath')]
        [Parameter(Mandatory=$true, ParameterSetName='ID')]
        [Guid]$ID,

        [Parameter(ParameterSetName='Content')]
        [Switch]$Content,

        [Parameter(ParameterSetName='FilePath')]
        [String]$FilePath,

        [Parameter(ParameterSetName='FilePath')]
        [Switch]$Force
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

        $apiTarget = "attachments/$($ID)"

        if ($PSBoundParameters.ContainsKey('Content') -or $PSBoundParameters.ContainsKey('FilePath'))
        {
            $apiTarget = $apiTarget + '/content'
        }

        $parms = @{
            ContentType     = 'application/json'
            Headers         = @{
                                    Authorization = 'Bearer ' + $Bearer
                                }
            Method          = 'Get'
            Uri             = (Get-TdpscApiBaseAddress) + $apiTarget
            UseBasicParsing = $true
        }

        Write-Debug -Message ($parms | Out-String)

        $request = Invoke-WebRequest @parms

        if ($PSBoundParameters.ContainsKey('Content'))
        {
            $request.Content
        }
        elseif ($PSBoundParameters.ContainsKey('FilePath'))
        {
            if ((Test-Path -Path $FilePath) -eq $true -and $PSBoundParameters.ContainsKey('Force') -eq $false)
            {
                Write-Error -Message "The file '$($FilePath)' already exists."
            }
            else
            {
                [System.IO.File]::WriteAllBytes($FilePath, $request.Content)
            }
        }
        else
        {
            if ((Get-TdReturnApiType) -eq $true)
            {
                ConvertTo-JsonDeserializeObject -String $request.Content -Type TeamDynamix.Api.Attachments.Attachment
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
