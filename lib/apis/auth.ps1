<#
    Contains methods for authentication.

    https://app.teamdynamix.com/TDWebApi/Home/section/Auth
#>

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

function New-TdpscAuth
{
    <#
    .SYNOPSIS
        Logs in the current session.
    .DESCRIPTION
        Use New-TdpscAuth to login with the specified parameters.
    .PARAMETER Credential
        Specifies a user account that has permission to perform this action.

        Type a user name, such as "User@example.com", or enter a PSCredential object, such as one returned by the Get-Credential cmdlet.

        When you type a user name, you will be prompted for a password.
    .EXAMPLE
        New-TdpscAuth

        Prompt for user name and password. Internal bearer is automatically updated.

        Returns the bearer token.
    .EXAMPLE
        $userName   = 'galexis@example.com'
        $password   = 'not-very-secure' | ConvertTo-SecureString -AsPlainText -Force
        $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $userName, $password
        $bearer     = New-TdpscAuth -Credential $credential

        Returns bearer token by passing user name and password via parameter. Internal bearer is automatically updated.
    .EXAMPLE
        $userName   = 'galexis@example.com'
        $password   = 'not-very-secure' | ConvertTo-SecureString -AsPlainText -Force
        $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $userName, $password
        $bearer     = $credential | New-TdpscAuth

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
                Uri             = (Get-TdpscApiBaseAddress) + 'auth'
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

function New-TdpscAuthCached
{
    <#
    .SYNOPSIS
        Logs in the current session with cached credentials.
    .DESCRIPTION
        Use New-TdpscAuthCached to login with the cached credentials. If cached token is invalid, function will use stored credentials. If user credentials are invalid, user will be prompted for new credentials.
    .PARAMETER UserNameFile
        The file containing the user name.
    .PARAMETER PasswordFile
        The file containing the password.
    .PARAMETER BearerFile
        The file containing the bearer token.
    .PARAMETER IsAdminCredential
        Specifies to perform an administrative login. Default value is $false.
    .PARAMETER RetryCount
        The current login attempt. The default value is 1. This value should not be used by the user.
    .PARAMETER MaxRetry
        The maximum number of attempts to try to login. The default is 3.
    .EXAMPLE
        $userNameFile = "$PSScriptRoot\..\_secret\credentials-user.username.txt"
        $passwordFile = "$PSScriptRoot\..\_secret\credentials-user.password.txt"
        $bearerFile   = "$PSScriptRoot\..\_secret\credentials-user.bearer.txt"

        $bearer = New-TdpscAuthCached -UserNameFile $userNameFile -PasswordFile $passwordFile -BearerFile $bearerFile

        Returns the bearer token for a user.
    .EXAMPLE
        $userNameFile = "$PSScriptRoot\..\_secret\credentials-admin.username.txt"
        $passwordFile = "$PSScriptRoot\..\_secret\credentials-admin.password.txt"
        $bearerFile   = "$PSScriptRoot\..\_secret\credentials-admin.bearer.txt"

        $bearer = New-TdpscAuthCached -UserNameFile $userNameFile -PasswordFile $passwordFile -BearerFile $bearerFile -IsAdminCredential $true

        Returns the bearer token for an administrator.
    .INPUTS
        None
        You cannot pipe objects to this cmdlet.
    .OUTPUTS
        None or String
        New-TdpscAuthCached returns a String object that represents the bearer token to be included with subsequent requests. Otherwise, this cmdlet does not generate any output.
    #>

    [CmdletBinding(PositionalBinding=$false, SupportsShouldProcess=$true)]
    [OutputType([String])]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
		[String]$UserNameFile,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
		[String]$PasswordFile,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
		[String]$BearerFile,

		[Boolean]$IsAdminCredential = $false,

        [Int32]$RetryCount = 1,

        [Int32]$MaxRetry = 3
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

        if ($PSCmdlet.ShouldProcess("Login using file $($UserNameFile)", 'Create Login Session'))
        {
            $result  = $null
            $refresh = $false

            if (Test-Path -Path $BearerFile) {
                Write-Debug -Message "Reading Bearer file: $BearerFile"

                $result =  Get-Content -Path $BearerFile
                $User = $result | Get-TdpscLoginSession
                if ($null -eq $User) {
                    Write-Debug -Message 'Need to refresh Bearer token!'
                    $refresh = $true
                }
            }
            else
            {
                $refresh = $true
            }

            if ($refresh -eq $true) {
                if ((Test-Path -Path $UserNameFile) -and (Test-Path -Path $PasswordFile)) {
                    Write-Debug -Message "Reading UserName file: $UserNameFile"
                    Write-Debug -Message "Reading Password file: $PasswordFile"
                    $userName = Get-Content -Path $UserNameFile
                    $password = Get-Content -Path $PasswordFile | ConvertTo-SecureString
                    $credentials = New-Object -TypeName System.Management.Automation.PsCredential -ArgumentList $userName,$password
                }
                else
                {
                    $credentials = Get-Credential

                    # Store credentials to file.
                    $credentials.UserName | Set-Content -Path $UserNameFile
                    $credentials.Password | ConvertFrom-SecureString | Set-Content -Path $PasswordFile
                }

                if ($null -ne $credentials)
                {
                    if ($IsAdminCredential -eq $true ) {
                        $result = $credentials | New-TdpscLoginAdminSession
                    }
                    else
                    {
                        $result = $credentials | New-TdpscLoginSession
                    }
                }

                if ($null -eq $result) {
                    if ($RetryCount -lt $MaxRetry) {
                        Write-Debug -Message "Possible incorrect credentials. Removing old cached credentials. Calling function again ($RetryCount/$MaxRetry)."
                        Remove-Item -Path $UserNameFile -Force
                        Remove-Item -Path $PasswordFile -Force
                        Remove-Item -Path $BearerFile -Force

                        $result = New-TdpscAuthCached -UserNameFile $UserNameFile -PasswordFile $PasswordFile -BearerFile $BearerFile -IsAdminCredential $IsAdminCredential -RetryCount ($RetryCount + 1) -MaxRetry $MaxRetry
                    }
                    else
                    {
                        Write-Debug -Message "Reached the limit of ($RetryCount/$MaxRetry) login attempts."
                    }
                }
                else
                {
                    $result | Set-Content -Path $BearerFile | Out-Null
                }
            }

            Set-InternalBearer -Bearer $result.ToString() -PassThru
        }
    }
    End
    {
        Write-Debug -Message "[$($MyInvocation.MyCommand.Name)] complete"
    }
}

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

function New-TdpscAuthLoginSso
{
    <#
    .SYNOPSIS
        Logs in the current session using single sign-on (SSO).
    .DESCRIPTION
        Use New-TdpscAuthLoginSso to automatically login with your SSO credentials.

        Your web browser will need to be configured to match the authentication requirements of your SSO provider. For example, Windows Authentication may need to be enabled on the website for a specific Internet zone. Your SSO provider may also require either JavaScript or cookies to be enabled.
    .PARAMETER DomainName
        The subdomain of your TeamDynamix website.
    .PARAMETER WebClient
        The type of web browser you are using. The internal WebBrowser form is the default.
    .PARAMETER WebSession
        The WebRequestSession, created by contacting your SSO provider.
    .PARAMETER Width
        The width of your internal WebBrowser.
    .PARAMETER Height
        The height of your internal WebBrowser.
    .PARAMETER StartPosition
        The starting position of your internal WebBrowser.
    .PARAMETER Title
        The form title of your internal WebBrowser.
    .EXAMPLE
        New-TdpscAuthLoginSso -DomainName 'myuniversity'

        Uses the builtin WebBrowser control to display the SSO webpage. A browser window will be displayed.

        Returns the bearer token.
    .EXAMPLE
        New-TdpscAuthLoginSso -DomainName 'myuniversity' -WebClient 'InternetExplorer'

        Uses Internet Explorer to display the SSO webpage. A browser window will be displayed.

        Returns the bearer token.
    .EXAMPLE
        Invoke-WebRequest -Uri 'https://idp.myuniversity.edu/idp/login-options.jsp' -SessionVariable 'idpSession' -Method Post -Body 'chkLoginOptions=2' -UseBasicParsing -UseDefaultCredentials | Out-Null
        New-TdpscAuthLoginSso -DomainName 'myuniversity' -WebClient 'WebRequest' -WebSession ([ref]$idpSession)

        Creates a session with a specific SSO provider, setting the initial SSO options. Contacts TeamDynamix API with the provided session reference.

        A browser window will not be displayed.

        This example is very specific and can vary depending on your SSO provider.

        Returns the bearer token.
    .INPUTS
        None
        You cannot pipe objects to this cmdlet.
    .OUTPUTS
        None or String
        New-TdpscAuthLoginSso returns a String object that represents the bearer token to be included with subsequent requests. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/Auth#GETapi/auth/loginsso

        FormStartPosition Enumeration
        https://msdn.microsoft.com/en-us/library/system.windows.forms.formstartposition(v=vs.110).aspx
    #>

    [CmdletBinding(DefaultParameterSetName='WebBrowser', SupportsShouldProcess=$true)]
    [OutputType([String])]
    Param
    (
        [Parameter(Mandatory=$true, ParameterSetName='InternetExplorer')]
        [Parameter(Mandatory=$true, ParameterSetName='WebBrowser')]
        [Parameter(Mandatory=$true, ParameterSetName='WebRequest')]
        [ValidateNotNullOrEmpty()]
        [String]$DomainName,

        [Parameter(ParameterSetName='InternetExplorer')]
        [Parameter(ParameterSetName='WebBrowser')]
        [Parameter(ParameterSetName='WebRequest')]
        [ValidateSet('InternetExplorer', 'WebBrowser', 'WebRequest')]
        [String]$WebClient = 'WebBrowser',

        [Parameter(ParameterSetName='WebRequest')]
        [Microsoft.PowerShell.Commands.WebRequestSession]$WebSession,

        [Parameter(ParameterSetName='WebBrowser')]
        [Int32]$Width = 640,

        [Parameter(ParameterSetName='WebBrowser')]
        [Int32]$Height = 640,

        [Parameter(ParameterSetName='WebBrowser')]
        [String]$StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent,

        [Parameter(ParameterSetName='WebBrowser')]
        [String]$Title = 'SSO Login'
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

        $result      = $null
        $uriLoginSso = ((Get-TdpscApiBaseAddress) -replace '/app(.teamdynamix.com)', "/$DomainName`$1") + 'auth/loginsso'
        $ieState     = @{
            READYSTATE_UNINITIALIZED = 0
            READYSTATE_LOADING       = 1
            READYSTATE_LOADED        = 2
            READYSTATE_INTERACTIVE   = 3
            READYSTATE_COMPLETE      = 4
        }

        if ($PSCmdlet.ShouldProcess("Login to $($uriLoginSso)", 'Create Login Session'))
        {
            if ($WebClient -eq 'InternetExplorer')
            {
                Write-Debug -Message 'Web Client: Using Internet Explorer'
                Write-Debug -Message "URL: $($uriLoginSso)"

                $web         = New-Object -ComObject InternetExplorer.Application
                $web.Visible = $true

                $web.Navigate($uriLoginSso) | Out-Null

                Do
                {
                    Start-Sleep -Milliseconds 1000
                }
                While (-not ($web.LocationURL -eq $uriLoginSso -and $web.ReadyState -eq $ieState.READYSTATE_COMPLETE))

                if ($web.LocationURL -eq $uriLoginSso)
                {
                    $result = $web.Document.Body.innerText.ToString()
                }

                $web.Quit() | Out-Null
            }
            elseif ($PSBoundParameters.ContainsKey('WebSession') -and $WebClient -eq 'WebRequest')
            {
                Write-Debug -Message 'Web Client: Using Invoke-WebRequest.'
                Write-Debug -Message "URL: $($uriLoginSso)"

                $request = Invoke-WebRequest -Uri $uriLoginSso -WebSession $WebSession -Method Get -UseBasicParsing
                $request = Invoke-WebRequest -Uri 'https://shib.teamdynamix.com/Shibboleth.sso/SAML2/POST' -WebSession $WebSession -Method Post -UseBasicParsing -Body @{ $request.InputFields[0].name = [System.Web.HttpUtility]::HtmlDecode($request.InputFields[0].value); $request.InputFields[1].name = [System.Web.HttpUtility]::HtmlDecode($request.InputFields[1].value) }
                $result  = $request.Content
            }
            else
            {
                Write-Debug -Message 'Web Client: Using internals web browser.'
                Write-Debug -Message "URL: $($uriLoginSso)"

                $web  = New-Object -TypeName System.Windows.Forms.WebBrowser -Property @{Dock=[System.Windows.Forms.DockStyle]::Fill}
                $form = New-Object -TypeName System.Windows.Forms.Form -Property @{Width=$Width; Height=$Height; StartPosition=$StartPosition; Text=$Title}

                $onDocumentCompleted = {
                    if ($web.Url.AbsoluteUri -eq $uriLoginSso)
                    {
                        $form.Close()
                    }
                }

                $web.Add_DocumentCompleted($onDocumentCompleted)
                $web.Navigate($uriLoginSso)

                $form.Add_Shown({$form.Activate()})
                $form.Controls.Add($web)
                $form.ShowDialog() | Out-Null

                if ($web.Url.AbsoluteUri -eq $uriLoginSso)
                {
                    $result = $web.Document.Body.innerText.ToString()
                }

                $web.Dispose()
                $form.Close()
                $form.Dispose()
            }

            Write-Debug -Message "Testing bearer: [$($result)]"
            Set-InternalBearer -Bearer $result -PassThru
        }
    }
    End
    {
        Write-Debug -Message "[$($MyInvocation.MyCommand.Name)] complete"
    }
}


Set-Alias -Name New-TdpscLoginSession       -Value New-TdpscAuth
Set-Alias -Name New-TdpscLoginAdminSession  -Value New-TdpscAuthLoginAdmin
Set-Alias -Name New-TdpscCachedLoginSession -Value New-TdpscAuthCached
Set-Alias -Name Get-TdpscLoginSession       -Value Get-TdpscAuth

Export-ModuleMember -Function Get-TdpscAuth           -Alias Get-TdpscLoginSession
Export-ModuleMember -Function New-TdpscAuth           -Alias New-TdpscLoginSession
Export-ModuleMember -Function New-TdpscAuthCached     -Alias New-TdpscCachedLoginSession
Export-ModuleMember -Function New-TdpscAuthLogin
Export-ModuleMember -Function New-TdpscAuthLoginAdmin -Alias New-TdpscLoginAdminSession
Export-ModuleMember -Function New-TdpscAuthLoginSso
