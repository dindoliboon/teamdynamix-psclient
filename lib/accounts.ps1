<#
.Synopsis
    Gets a list of all active accounts/departments.
.PARAMETER Bearer
    Bearer token received when logging in.
.EXAMPLE
    Pass the bearer token by parameter.

    $accounts = Get-TdpscAccounts -Bearer $Bearer
.EXAMPLE
    Pipe the bearer token to Get-TdpscLoginSession.

    $accounts = "My Bearer Token" | Get-TdpscAccounts
.INPUTS
    System.String

    You can pipe a bearer token (string) to Get-TdpscAccounts.
.OUTPUTS
    PSObject. A list of all active accounts/departments. (IEnumerable(Of TeamDynamix.Api.Accounts.Account))
.LINK
    https://app.teamdynamix.com/TDWebApi/Home/section/Accounts#GETapi/accounts
#>
function Get-TdpscAccount
{
    [CmdletBinding(DefaultParameterSetName='Bearer',
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
                   ParameterSetName='Bearer')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({$_.PSObject.TypeNames[0] -eq 'System.String'})]
		[String]$Bearer
    )

    Begin
    {
        $url    = 'https://app.teamdynamix.com/TDWebApi/api/accounts'
        $result = $null
    }
    Process
    {
        if ($PSCmdlet.ShouldProcess($Credential, 'Logs in the current session with the specified parameters.'))
        {
            $resp    = Invoke-WebRequest -Uri $url -ContentType 'application/json' -Method Get -Headers @{'Authorization' = 'Bearer ' + $Bearer}
            $result  = $resp.Content | ConvertFrom-Json
        }
    }
    End
    {
        $result
    }
}

Export-ModuleMember -Function Get-TdpscAccount
