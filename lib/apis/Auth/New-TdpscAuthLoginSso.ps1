#Requires -Version 3

Set-StrictMode -Version 3

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
