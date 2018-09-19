#Requires -Version 3

Set-StrictMode -Version 3

function Get-TdpscAccount
{
    <#
    .SYNOPSIS
        Retrieve active accounts/departments.
    .DESCRIPTION
        Use Get-TdpscAccount to view all active accounts/departments, search for accounts matching provided criteria or return an individual account based on ID or name, or supply account information to other tasks.
    .PARAMETER Bearer
        Bearer token received when logging in. Can be passed by the pipeline or parameter. If null or empty, value is obtained by Get-InternalBearer.
    .PARAMETER Name
        The name of the account/department to search for. Must match the full name. Name is not case-sensitive.
    .PARAMETER ID
        The ID of the account/department to search for. Must match the full ID number.
    .PARAMETER Search
        The searching parameters to use. Parameters can be contained in either a [Hashtable] or [TeamDynamix.Api.Accounts.AccountSearch] object.
    .EXAMPLE
        Get-TdpscAccount

        Returns all accounts that have property IsActive=true.
    .EXAMPLE
        Get-TdpscAccount -ID 32746

        Returns account that matches requested ID and has property IsActive=true.
    .EXAMPLE
        Get-TdpscAccount -Name 'Awesome Department'

        Returns accounts that matches name exactly and has property IsActive=true.
    .EXAMPLE
        Get-TdpscAccount -Search @{'SearchText' = 'Awesome'}

        Returns accounts that matches the searching parameters and has property IsActive=true. When using SearchText, it will perform a case-insensitive wildcard search.
    .EXAMPLE
        $accountSearch = New-Object -TypeName TeamDynamix.Api.Accounts.AccountSearch
        $accountSearch.SearchText = 'Awesome'
        $accountSearch.MaxResults = 1
        Get-TdpscAccount -Search $accountSearch

        Returns accounts that matches the searching parameters and has property IsActive=true. When using SearchText, it will perform a case-insensitive wildcard search.
    .INPUTS
        String
        You can pipe a String that contains a bearer token.
    .OUTPUTS
        None or PSObject or TeamDynamix.Api.Accounts.Account or System.Object[].
        Get-TdpscAccount returns a System.Object[] object if multiple users are returned. If a single user is found, Get-TdpscAccount returns a PSObject or TeamDynamix.Api.Accounts.Account object. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/Accounts#GETapi/accounts
    #>

    [CmdletBinding(DefaultParameterSetName='Bearer')]
    [OutputType([PSObject], [TeamDynamix.Api.Accounts.Account], [System.Object[]])]
    Param
    (
        [Parameter(ParameterSetName='Bearer',   Position=0, ValueFromPipeline=$true)]
        [Parameter(ParameterSetName='ByName',   Position=0, ValueFromPipeline=$true)]
        [Parameter(ParameterSetName='ById',     Position=0, ValueFromPipeline=$true)]
        [Parameter(ParameterSetName='BySearch', Position=0, ValueFromPipeline=$true)]
		[String]$Bearer,

        [Parameter(ParameterSetName='ByName')]
        [String]$Name,

        [Parameter(ParameterSetName='ById')]
        [Int32]$ID,

        [Parameter(ParameterSetName='BySearch')]
        [Object]$Search
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

        if ($PSCmdlet.ParameterSetName -eq 'BySearch')
        {
            $parms = @{
                Body            = ConvertTo-JsonSerializeObject -InputObject $Search
                ContentType     = 'application/json'
                Headers         = @{
                                        Authorization = 'Bearer ' + $Bearer
                                    }
                Method          = 'Post'
                Uri             = (Get-TdpscApiBaseAddress) + 'accounts/search'
                UseBasicParsing = $true
            }
        }
        else
        {
            $parms = @{
                ContentType     = 'application/json'
                Headers         = @{
                                        Authorization = 'Bearer ' + $Bearer
                                    }
                Method          = 'Get'
                Uri             = (Get-TdpscApiBaseAddress) + 'accounts'
                UseBasicParsing = $true
            }
        }

        Write-Debug -Message ($parms | Out-String)

        $request = Invoke-WebRequest @parms

        if ((Get-TdReturnApiType) -eq $true)
        {
            $accounts = ConvertTo-JsonDeserializeObject -String $request.Content -Type TeamDynamix.Api.Accounts.Account[]
        }
        else
        {
            $accounts = $request.Content | ConvertFrom-Json
        }

        if ($PSBoundParameters.ContainsKey('Name'))
        {
            # Can return multiple objects.
            Write-Debug -Message 'Checking accounts result with name'
            $accounts | Where-Object { $_.Name -eq $Name}
        }
        elseif ($PSBoundParameters.ContainsKey('ID'))
        {
            # Should only return 0 or 1 object.
            Write-Debug -Message 'Checking accounts result with ID'
            $accounts | Where-Object { $_.ID -eq $ID}
        }
        else
        {
            # Can return multiple objects.
            Write-Debug -Message 'Return raw accounts results'
            $accounts
        }
    }
    End
    {
        Write-Debug -Message "[$($MyInvocation.MyCommand.Name)] complete"
    }
}
