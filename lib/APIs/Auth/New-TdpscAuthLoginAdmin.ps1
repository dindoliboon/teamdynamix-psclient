#Requires -Version 3

Set-StrictMode -Version 3

function New-TdpscAuthLoginAdmin
{
    <#
    .SYNOPSIS
        Logs in the current session using an administrative account.
    .DESCRIPTION
        Use New-TdpscAuthLoginAdmin to login with an administrative account.
    .PARAMETER Credential
        Specifies a user account that has permission to perform this action.

        Type a user name, such as "f23d3f8a-a752-4468-8fe2-dedb60a370b7", or enter a PSCredential object, such as one returned by the Get-Credential cmdlet.

        When you type a user name, you will be prompted for a password.
    .EXAMPLE
        New-TdpscAuthLoginAdmin

        Prompt for user name and password. Internal bearer is automatically updated.

        Returns the bearer token.
    .EXAMPLE
        $userName   = 'f23d3f8a-a752-4468-8fe2-dedb60a370b7'
        $password   = '3ba8bdc8-8d09-4a4d-b4b0-1ac03e90422d' | ConvertTo-SecureString -AsPlainText -Force
        $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $userName, $password
        $bearer     = New-TdpscAuthLoginAdmin -Credential $credential

        Returns bearer token by passing user name and password via parameter. Internal bearer is automatically updated.
    .EXAMPLE
        $userName   = 'f23d3f8a-a752-4468-8fe2-dedb60a370b7'
        $password   = '3ba8bdc8-8d09-4a4d-b4b0-1ac03e90422d' | ConvertTo-SecureString -AsPlainText -Force
        $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $userName, $password
        $bearer     = $credential | New-TdpscAuthLoginAdmin

        Returns bearer token by passing user name and password via pipeline. Internal bearer is automatically updated.
    .INPUTS
        System.Management.Automation.PSCredential
        You can pipe a PSCredential that contains the login credentials.
    .OUTPUTS
        None or String
        New-TdpscAuthLoginAdmin returns a String object that represents the bearer token to be included with subsequent requests. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/Auth#POSTapi/auth/loginadmin
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

        $loginParams                = New-Object -TypeName TeamDynamix.Api.Auth.AdminTokenParameters
        $loginParams.BEID           = $Credential.GetNetworkCredential().UserName
        $loginParams.WebServicesKey = $Credential.GetNetworkCredential().Password

        if ($PSCmdlet.ShouldProcess("Login as $($loginParams.BEID)", 'Create Login Session'))
        {
            $parms = @{
                Body            = ConvertTo-JsonSerializeObject -InputObject $loginParams
                ContentType     = 'application/json'
                Method          = 'Post'
                Uri             = (Get-TdpscApiBaseAddress) + 'auth/loginadmin'
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

Set-Alias -Name New-TdpscLoginAdminSession -Value New-TdpscAuthLoginAdmin
