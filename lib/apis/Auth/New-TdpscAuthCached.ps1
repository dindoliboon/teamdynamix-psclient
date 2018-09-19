#Requires -Version 3

Set-StrictMode -Version 3

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

Set-Alias -Name New-TdpscCachedLoginSession -Value New-TdpscAuthCached
