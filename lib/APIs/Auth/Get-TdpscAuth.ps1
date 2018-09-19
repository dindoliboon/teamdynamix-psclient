#Requires -Version 3

Set-StrictMode -Version 3

function Get-TdpscAuth
{
    <#
    .SYNOPSIS
        Gets the current user.
    .DESCRIPTION
        Use Get-TdpscAuth to retrieve the details of the currently logged-in user.
    .PARAMETER Bearer
        Bearer token received when logging in. If null or empty, value is obtained by Get-InternalBearer.
    .EXAMPLE
        Get-TdpscAuth

        Returns the currently logged in user with the internal bearer.
    .EXAMPLE
        Get-TdpscAuth -Bearer 'mybearer'

        Returns the currently logged in user with a specified bearer.
    .EXAMPLE
        'mybearer' | Get-TdpscAuth

        Returns the currently logged in user with a bearer passed by pipeline.
    .INPUTS
        System.String
        You can pipe a string that contains a bearer token.
    .OUTPUTS
        None or PSObject or TeamDynamix.Api.Users.User
        Get-TdpscAuth returns a PSObject or TeamDynamix.Api.Users.User object that represents the current user if the Bearer parameter contains a valid token. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/Auth#GETapi/auth/getuser
    #>

    [CmdletBinding()]
    [OutputType([PSObject], [TeamDynamix.Api.Users.User])]
    Param
    (
        [Parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
		[String]$Bearer
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

        if ([String]::IsNullOrWhiteSpace($Bearer))
        {
            $Bearer = Get-InternalBearer
        }

        if ([String]::IsNullOrWhiteSpace($Bearer) -eq $false)
        {
            $parms = @{
                ContentType     = 'application/json'
                Headers         = @{
                                        Authorization = 'Bearer ' + $Bearer
                                  }
                Method          = 'Get'
                Uri             = (Get-TdpscApiBaseAddress) + 'auth/getuser'
                UseBasicParsing = $true
            }

            Write-Debug -Message ($parms | Out-String)

            $request = Invoke-WebRequest @parms

            if ((Get-TdReturnApiType) -eq $true)
            {
                ConvertTo-JsonDeserializeObject -String $request.Content -Type TeamDynamix.Api.Users.User
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

Set-Alias -Name Get-TdpscLoginSession -Value Get-TdpscAuth
