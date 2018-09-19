#Requires -Version 3

Set-StrictMode -Version 3

function Get-TdpscPerson
{
    <#
    .SYNOPSIS
        Gets a person from the system.
    .DESCRIPTION
        Use Get-TdpscPerson to return an individual person based on ID or supply account information to other tasks.
    .PARAMETER Bearer
        Bearer token received when logging in.
    .PARAMETER UID
        The user unique identifier.
    .EXAMPLE
        Get-TdpscPerson -UID 'ec57223c-980c-4d17-8133-d9553f49b519'

        Return the person matching the requested UID.
    .INPUTS
        String
        You can pipe a String that contains a bearer token.
    .OUTPUTS
        None or PSObject or TeamDynamix.Api.Users.User
        Get-TdpscAccount returns a PSObject or TeamDynamix.Api.Users.User object if a person is found. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/People#GETapi/people/{uid}
    #>

    [CmdletBinding()]
    [OutputType([PSObject], [TeamDynamix.Api.Users.User])]
    Param
    (
        [Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
		[String]$Bearer,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
		[String]$UID
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
            Uri             = (Get-TdpscApiBaseAddress) + "people/$($UID)"
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
    End
    {
        Write-Debug -Message "[$($MyInvocation.MyCommand.Name)] complete"
    }
}
