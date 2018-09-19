#Requires -Version 3

Set-StrictMode -Version 3

function New-TdpscAuthLogin
{
    <#
    .SYNOPSIS
        Logs in the current session.
    .DESCRIPTION
        Use New-TdpscAuthLogin to login with the specified parameters.
    .PARAMETER Credential
        Specifies a user account that has permission to perform this action.

        Type a user name, such as "User@example.com", or enter a PSCredential object, such as one returned by the Get-Credential cmdlet.

        When you type a user name, you will be prompted for a password.
    .EXAMPLE
        New-TdpscAuthLogin

        Prompt for user name and password. Internal bearer is automatically updated.

        Returns the bearer token.
    .EXAMPLE
        $userName   = 'galexis@example.com'
        $password   = 'not-very-secure' | ConvertTo-SecureString -AsPlainText -Force
        $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $userName, $password
        $bearer     = New-TdpscAuthLogin -Credential $credential

        Returns bearer token by passing user name and password via parameter. Internal bearer is automatically updated.
    .EXAMPLE
        $userName   = 'galexis@example.com'
        $password   = 'not-very-secure' | ConvertTo-SecureString -AsPlainText -Force
        $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $userName, $password
        $bearer     = $credential | New-TdpscAuthLogin

        Returns bearer token by passing user name and password via pipeline. Internal bearer is automatically updated.
    .INPUTS
        System.Management.Automation.PSCredential
        You can pipe a PSCredential that contains the login credentials.
    .OUTPUTS
        None or String
        New-TdpscAuth returns a String object that represents the bearer token to be included with subsequent requests. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/Auth#POSTapi/auth
    #>

    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([String])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $Credential
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

        $loginParams          = New-Object -TypeName TeamDynamix.Api.Auth.LoginParameters
        $loginParams.UserName = $Credential.GetNetworkCredential().UserName
        $loginParams.Password = $Credential.GetNetworkCredential().Password

        if ($PSCmdlet.ShouldProcess("Login as $($loginParams.UserName)", 'Create Login Session'))
        {
            $parms = @{
                Body            = ConvertTo-JsonSerializeObject -InputObject $loginParams
                ContentType     = 'application/json'
                Method          = 'Post'
                Uri             = (Get-TdpscApiBaseAddress) + 'auth/login'
                UseBasicParsing = $true
            }

            Write-Debug -Message ($parms | Out-String)

            $request = Invoke-WebRequest @parms

            Set-InternalBearer -Bearer $request.Content -PassThru
        }
    }
    End
    {
        Write-Debug -Message "[$($MyInvocation.MyCommand.Name)] complete"
    }
}
