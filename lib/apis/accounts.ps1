#Requires -Version 3

Set-StrictMode -Version 3

function Get-TdpscAccount
{
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
        $url    = 'https://app.teamdynamix.com/TDWebApi/api/accounts'
        $result = $null
    }
    Process
    {
        $resp    = Invoke-WebRequest -Uri $url -ContentType 'application/json' -Method Get -Headers @{'Authorization' = 'Bearer ' + $Bearer} -UseBasicParsing
        $result  = $resp.Content | ConvertFrom-Json
    }
    End
    {
        $result
    }
}

Export-ModuleMember -Function Get-TdpscAccount
