#Requires -Version 3

Set-StrictMode -Version 3

function New-TdpscLoginSession
{
    <#
    .Synopsis
        Logs in the current session with the specified parameters.
    .PARAMETER Credential
        The login parameters.
    .EXAMPLE
        Pass the login information by parameter.

        $Bearer = New-TdpscLoginSession -Credential $Credential
    .EXAMPLE
        Pipe the credentials to New-TdpscLoginSession.

        $Bearer = Get-Credential | New-TdpscLoginSession
    .INPUTS
        PSCredential

        You can pipe a credentials (PSCredential) to New-TdpscLoginSession.
    .OUTPUTS
        String. The authentication result, which will include the text of the necessary "Bearer" token to be included with subsequent requests.
    .LINK
        https://app.teamdynamix.com/TDWebApi/Home/section/Auth#POSTapi/auth
    #>

    [CmdletBinding(DefaultParameterSetName='Credential',
                  SupportsShouldProcess=$true,
                  PositionalBinding=$false,
                  ConfirmImpact='Low')]
    [OutputType([PSObject])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromRemainingArguments=$false,
                   Position=0,
                   ParameterSetName='Credential')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [PSCredential]$Credential
    )

    Begin
    {
        $url    = 'https://app.teamdynamix.com/TDWebApi/api/auth'
        $result = $null
    }
    Process
    {
        if ($PSCmdlet.ShouldProcess($Credential, 'Logs in the current session with the specified parameters.'))
        {
            $request = @{
                'UserName' = $Credential.GetNetworkCredential().UserName
                'Password' = $Credential.GetNetworkCredential().Password
                } | ConvertTo-Json -Compress
            $resp    = Invoke-WebRequest -Uri $url -Body $request -ContentType 'application/json' -Method Post -UseBasicParsing
            $result  = $resp.Content
        }
    }
    End
    {
        $result
    }
}

function New-TdpscLoginAdminSession
{
    <#
    .Synopsis
        Logs in the current session using an administrative account.
    .PARAMETER Credential
        The administrative account parameters.
    .EXAMPLE
        Pass the login information by parameter.

        $Bearer = New-TdpscLoginAdminSession -Credential $Credential
    .EXAMPLE
        Pipe the credentials to New-TdpscLoginAdminSession.

        $Bearer = Get-Credential | New-TdpscLoginAdminSession
    .INPUTS
        PSCredential

        You can pipe a credentials (PSCredential) to New-TdpscLoginAdminSession.
    .OUTPUTS
        String. The authentication result, which will include the text of the necessary "Bearer" token to be included with subsequent requests.
    .LINK
        https://app.teamdynamix.com/TDWebApi/Home/section/Auth#POSTapi/auth/loginadmin
    #>

    [CmdletBinding(DefaultParameterSetName='Credential',
                  SupportsShouldProcess=$true,
                  PositionalBinding=$false,
                  ConfirmImpact='Low')]
    [OutputType([PSObject])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromRemainingArguments=$false,
                   Position=0,
                   ParameterSetName='Credential')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [PSCredential]$Credential
    )

    Begin
    {
        $url    = 'https://app.teamdynamix.com/TDWebApi/api/auth/loginadmin'
        $result = $null
    }
    Process
    {
        if ($PSCmdlet.ShouldProcess($Credential, 'Logs in the current session using an administrative account.'))
        {
            $request = @{
                'BEID'           = $Credential.GetNetworkCredential().UserName
                'WebServicesKey' = $Credential.GetNetworkCredential().Password
                } | ConvertTo-Json -Compress
            $resp    = Invoke-WebRequest -Uri $url -Body $request -ContentType 'application/json' -Method Post -UseBasicParsing
            $result  = $resp.Content
        }
    }
    End
    {
        $result
    }
}

function New-TdpscCachedLoginSession
{
    <#
    .Synopsis
        Logs in the current session with cached credentials. If cached token is invalid, function will use stored credentials. If user credentials are invalid, user will be prompted for new credentials.
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
        Login with user credentials.

        $UserNameFile = "$PSScriptRoot\..\_secret\credentials-user.username.txt"
        $PasswordFile = "$PSScriptRoot\..\_secret\credentials-user.password.txt"
        $BearerFile   = "$PSScriptRoot\..\_secret\credentials-user.bearer.txt"

        $Bearer = New-TdpscCachedLoginSession -UserNameFile $UserNameFile -PasswordFile $PasswordFile -BearerFile $BearerFile
    .EXAMPLE
        Login with administrative credentials.

        $UserNameFile = "$PSScriptRoot\..\_secret\credentials-admin.username.txt"
        $PasswordFile = "$PSScriptRoot\..\_secret\credentials-admin.password.txt"
        $BearerFile   = "$PSScriptRoot\..\_secret\credentials-admin.bearer.txt"

        $Bearer = New-TdpscCachedLoginSession -UserNameFile $UserNameFile -PasswordFile $PasswordFile -BearerFile $BearerFile -IsAdminCredential $true
    .OUTPUTS
        String. The authentication result, which will include the text of the necessary "Bearer" token to be included with subsequent requests.
    .LINK
        https://app.teamdynamix.com/TDWebApi/Home/section/Auth#POSTapi/auth
    #>

    [CmdletBinding(SupportsShouldProcess=$true,
                  PositionalBinding=$false,
                  ConfirmImpact='Low')]
    [OutputType([PSObject])]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
		[String]$UserNameFile,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
		[String]$PasswordFile,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
		[String]$BearerFile,

		[Boolean]$IsAdminCredential = $false,

        [Int32]$RetryCount = 1,

        [Int32]$MaxRetry = 3
    )

    Begin
    {
        $url     = 'https://app.teamdynamix.com/TDWebApi/api/auth'
        $result  = $null
        $refresh = $false
    }
    Process
    {
        if ($PSCmdlet.ShouldProcess($UserNameFile, 'Logs in the current session with cached credentials.'))
        {
            if (Test-Path -Path $BearerFile) {
                Write-Verbose -Message "Reading Bearer file: $BearerFile"
                $result = Get-Content -Path $BearerFile

                $User = $result | Get-TdpscLoginSession
                if ($null -eq $User) {
                    Write-Verbose -Message 'Need to refresh Bearer token!'
                    $refresh = $true
                }
            } else {
                $refresh = $true
            }

            if ($refresh -eq $true) {
                if ((Test-Path -Path $UserNameFile) -and (Test-Path -Path $PasswordFile)) {
                    Write-Verbose -Message "Reading UserName file: $UserNameFile"
                    Write-Verbose -Message "Reading Password file: $PasswordFile"
                    $UserName = Get-Content -Path $UserNameFile
                    $Password = Get-Content -Path $PasswordFile | ConvertTo-SecureString
                    $Credentials = New-Object -TypeName System.Management.Automation.PsCredential -ArgumentList $UserName,$Password
                } else {
                    $Credentials = Get-Credential

                    # Store credentials to file.
                    $Credentials.UserName | Set-Content -Path $UserNameFile
                    $Credentials.Password | ConvertFrom-SecureString | Set-Content -Path $PasswordFile
                }

                if ($IsAdminCredential -eq $true ) {
                    $result = $Credentials | New-TdpscLoginAdminSession
                } else {
                    $result = $Credentials | New-TdpscLoginSession
                }

                if ($null -eq $result) {
                    if ($RetryCount -lt $MaxRetry) {
                        Write-Verbose -Message "Possible incorrect credentials. Removing old cached credentials. Calling function again ($RetryCount/$MaxRetry)."
                        Remove-Item -Path $UserNameFile -Force
                        Remove-Item -Path $PasswordFile -Force
                        Remove-Item -Path $BearerFile -Force

                        $result = New-TdpscCachedLoginSession -UserNameFile $UserNameFile -PasswordFile $PasswordFile -BearerFile $BearerFile -IsAdminCredential $IsAdminCredential -RetryCount ($RetryCount + 1) -MaxRetry $MaxRetry
                    } else {
                        Write-Verbose -Message "Reached the limit of ($RetryCount/$MaxRetry) login attempts."
                    }
                } else {
                    $result | Set-Content -Path $BearerFile
                }
            }
        }
    }
    End
    {
        $result
    }
}

function Get-TdpscLoginSession
{
    <#
    .Synopsis
        Gets the current user.
    .PARAMETER Bearer
        Bearer token received when logging in.
    .EXAMPLE
        Pass the bearer token by parameter.

        $user = Get-TdpscLoginSession -Bearer $Bearer
    .EXAMPLE
        Pipe the bearer token to Get-TdpscLoginSession.

        $user = "My Bearer Token" | Get-TdpscLoginSession
    .INPUTS
        System.String

        You can pipe a bearer token (string) to Get-TdpscLoginSession.
    .OUTPUTS
        PSObject. The current user. (TeamDynamix.Api.Users.User)
    .LINK
        https://app.teamdynamix.com/TDWebApi/Home/section/Auth#GETapi/auth/getuser
    #>

    [CmdletBinding(DefaultParameterSetName='Bearer',
                  PositionalBinding=$false)]
    [OutputType([PSObject])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromRemainingArguments=$false,
                   Position=0,
                   ParameterSetName='Bearer')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({$_.PSObject.TypeNames[0] -eq 'System.String'})]
		[String]$Bearer
    )

    Begin
    {
        $url    = 'https://app.teamdynamix.com/TDWebApi/api/auth/getuser'
        $result = $null
    }
    Process
    {
        $resp   = Invoke-WebRequest -Uri $url -ContentType 'application/json' -Method Get -Headers @{'Authorization' = 'Bearer ' + $Bearer} -UseBasicParsing
        $result = $resp.Content | ConvertFrom-Json
    }
    End
    {
        $result
    }
}

Export-ModuleMember -Function New-TdpscLoginSession
Export-ModuleMember -Function New-TdpscLoginAdminSession
Export-ModuleMember -Function New-TdpscCachedLoginSession
Export-ModuleMember -Function Get-TdpscLoginSession
