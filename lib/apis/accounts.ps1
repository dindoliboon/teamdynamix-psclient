<#
    Contains methods for working with accounts/departments.

    https://api.teamdynamix.com/TDWebApi/Home/section/Accounts
#>

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

function New-TdpscAccount
{
    <#
    .SYNOPSIS
        Creates a new account.
    .DESCRIPTION
        Use New-TdpscAccount to create a new account.

        This action requires the "Acct/Dept: Create Accts/Depts" permission.
    .PARAMETER Bearer
        Bearer token received when logging in. If null or empty, value is obtained by Get-InternalBearer.
    .PARAMETER Name
        Account/department name.
    .PARAMETER Address1
        First address line.

        Currently does not appear to update field using Web API.
    .PARAMETER Address2
        Second address line.

        Currently does not appear to update field using Web API.
    .PARAMETER Address3
        Third address line.

        Currently does not appear to update field using Web API.
    .PARAMETER Address4
        Fourth address line.

        Currently does not appear to update field using Web API.
    .PARAMETER City
        City.
    .PARAMETER StateAbbr
        Abbreviation of the state/province.
    .PARAMETER PostalCode
        Postal code.
    .PARAMETER Country
        Country.
    .PARAMETER Phone
        Phone number.
    .PARAMETER Fax
        Fax number.

        Currently does not appear to update field using Web API.
    .PARAMETER Url
        Website URL.

        Currently does not appear to update field using Web API.
    .PARAMETER Notes
        Account notes.

        Currently does not appear to update field using Web API.
    .PARAMETER Code
        Account code.
    .PARAMETER IndustryID
        Industry ID.

        Currently does not appear to update field using Web API.
    .PARAMETER Domain
        Domain.
    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.
    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.
    .EXAMPLE
        New-TdpscAccount -Name 'Awesome Department' -City 'Anytown' -StateAbbr 'USA' -PostalCode '12345' -Country 'USA' -Phone '555-555-5555'

        Creates a new account with the provided parameters.
    .EXAMPLE
        Get-TdpscAccount -ID 9000 | New-TdpscAccount -Name 'Awesome Department'

        Retrieves a specific account, passes information by pipeline. Creates a new account, using the pipeline information as a template.
    .EXAMPLE
        $account = New-Object -TypeName PSObject -Property @{
            Name  = 'Awesome Department'
            Phone = '555-555-5555'
        }
        $account | New-TdpscAccount

        Create a new account using information from a PSObject object, passed by pipeline.
    .EXAMPLE
        $account = New-Object -TypeName TeamDynamix.Api.Accounts.Account
        $account.Name  = 'Awesome Department'
        $account.Phone = '555-555-5555'
        $account | New-TdpscAccount

        Create a new account using information from an Account object, passed by pipeline.
    .EXAMPLE
        $account = New-Object -TypeName TeamDynamix.Api.Accounts.Account
        $account.Name  = 'Awesome Department'
        $account.Phone = '555-555-5555'
        $account | New-TdpscAccount -Name 'New Awesome Department'

        Create a new account using information from an Account object, passed by pipeline. Instead of using the Name from the pipeline, it will use the Name parameter instead.
    .INPUTS
        PSObject or TeamDynamix.Api.Accounts.Account
        You can pipe a PSObject or Account object that contains the information of the new account.
    .OUTPUTS
        None or PSObject or TeamDynamix.Api.Accounts.Account
        New-TdpscAccount returns a PSObject or Account object that contains the newly created account. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/Accounts#POSTapi/accounts
    #>

    [CmdletBinding(ConfirmImpact='Medium', SupportsShouldProcess=$true)]
    [OutputType([PSObject], [TeamDynamix.Api.Accounts.Account])]
    Param
    (
        [String]$Bearer,

        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [String]$Name,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$Address1,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$Address2,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$Address3,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$Address4,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$City,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$StateAbbr,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$PostalCode,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$Country,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$Phone,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$Fax,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$Url,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$Notes,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$Code,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Int32]$IndustryID,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$Domain
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

        if ($PSCmdlet.ShouldProcess("Account Name $($Name)", 'Create Account'))
        {
            if ([String]::IsNullOrWhiteSpace($Bearer)) { $Bearer = Get-InternalBearer }

            if ($null -ne $_ -and ($_.GetType().FullName -eq 'TeamDynamix.Api.Accounts.Account' -or $_.GetType().FullName -eq 'System.Management.Automation.PSCustomObject'))
            {
                Write-Debug -Message 'Use existing account information from pipeline'
                $parms = @{
                    'String' = ConvertTo-JsonSerializeObject -InputObject $_
                    'Type'   = [TeamDynamix.Api.Accounts.Account]
                }

                $accountModify = ConvertTo-JsonDeserializeObject @parms
            }
            else
            {
                $accountModify = New-Object -TypeName TeamDynamix.Api.Accounts.Account
            }

            $accountModify.Name       = ($accountModify.Name,             $Name)[$PSBoundParameters.ContainsKey('Name')]
            $accountModify.IsActive   = $true                       
            $accountModify.Address1   = ($accountModify.Address1,     $Address1)[$PSBoundParameters.ContainsKey('Address1')]
            $accountModify.Address2   = ($accountModify.Address2,     $Address2)[$PSBoundParameters.ContainsKey('Address2')]
            $accountModify.Address3   = ($accountModify.Address3,     $Address3)[$PSBoundParameters.ContainsKey('Address3')]
            $accountModify.Address4   = ($accountModify.Address4,     $Address4)[$PSBoundParameters.ContainsKey('Address4')]
            $accountModify.City       = ($accountModify.City,             $City)[$PSBoundParameters.ContainsKey('City')]
            $accountModify.StateAbbr  = ($accountModify.StateAbbr,   $StateAbbr)[$PSBoundParameters.ContainsKey('StateAbbr')]
            $accountModify.PostalCode = ($accountModify.PostalCode, $PostalCode)[$PSBoundParameters.ContainsKey('PostalCode')]
            $accountModify.Country    = ($accountModify.Country,       $Country)[$PSBoundParameters.ContainsKey('Country')]
            $accountModify.Phone      = ($accountModify.Phone,           $Phone)[$PSBoundParameters.ContainsKey('Phone')]
            $accountModify.Fax        = ($accountModify.Fax,               $Fax)[$PSBoundParameters.ContainsKey('Fax')]
            $accountModify.Url        = ($accountModify.Url,               $Url)[$PSBoundParameters.ContainsKey('Url')]
            $accountModify.Notes      = ($accountModify.Notes,           $Notes)[$PSBoundParameters.ContainsKey('Notes')]
            $accountModify.Code       = ($accountModify.Code,             $Code)[$PSBoundParameters.ContainsKey('Code')]
            $accountModify.IndustryID = ($accountModify.IndustryID, $IndustryID)[$PSBoundParameters.ContainsKey('IndustryID')]
            $accountModify.Domain     = ($accountModify.Domain,         $Domain)[$PSBoundParameters.ContainsKey('Domain')]

            $parms = @{
                Body            = ConvertTo-JsonSerializeObject -InputObject $accountModify
                ContentType     = 'application/json'
                Headers         = @{
                                        Authorization = 'Bearer ' + $Bearer
                                    }
                Method          = 'Post'
                Uri             = (Get-TdpscApiBaseAddress) + 'accounts'
                UseBasicParsing = $true
            }

            Write-Debug -Message ($parms | Out-String)

            $request = Invoke-WebRequest @parms

            if ((Get-TdReturnApiType) -eq $true)
            {
                ConvertTo-JsonDeserializeObject -String $request.Content -Type TeamDynamix.Api.Accounts.Account
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

function Set-TdpscAccount
{
    <#
    .SYNOPSIS
        Edits the account specified by the account ID.
    .DESCRIPTION
        Use Set-TdpscAccount update a specific account. Can receive pipeline from Get-TdpscAccount.

        This action requires the "Acct/Dept: Edit Accts/Depts" permission.
    .PARAMETER Bearer
        Bearer token received when logging in. If null or empty, value is obtained by Get-InternalBearer.
    .PARAMETER ID
        The ID of the account/department to search for. Must match the full ID number. Can receive ID from the pipeline with a [TeamDynamix.Api.Accounts.Account] object type.
    .PARAMETER Name
        Account/department name.
    .PARAMETER IsActive
        Active status. If set to false, the account will no longer be retrievable through the Web API.
    .PARAMETER Address1
        First address line.

        Currently does not appear to update field using Web API.
    .PARAMETER Address2
        Second address line.

        Currently does not appear to update field using Web API.
    .PARAMETER Address3
        Third address line.

        Currently does not appear to update field using Web API.
    .PARAMETER Address4
        Fourth address line.

        Currently does not appear to update field using Web API.
    .PARAMETER City
        City.
    .PARAMETER StateAbbr
        Abbreviation of the state/province.
    .PARAMETER PostalCode
        Postal code.
    .PARAMETER Country
        Country.
    .PARAMETER Phone
        Phone number.
    .PARAMETER Fax
        Fax number.

        Currently does not appear to update field using Web API.
    .PARAMETER Url
        Website URL.

        Currently does not appear to update field using Web API.
    .PARAMETER Notes
        Account notes.

        Currently does not appear to update field using Web API.
    .PARAMETER Code
        Account code.
    .PARAMETER IndustryID
        Industry ID.

        Currently does not appear to update field using Web API.
    .PARAMETER Domain
        Domain.
    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.
    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet is not run.
    .EXAMPLE
        Set-TdpscAccount -ID 32746 -City 'Anytown' -StateAbbr 'USA' -PostalCode '12345' -Country 'USA' -Phone '555-555-5555'

        Updates specific account with provided parameters.
    .EXAMPLE
        Get-TdpscAccount -ID 32746 | Set-TdpscAccount -City 'Anytown' -StateAbbr 'USA' -PostalCode '12345' -Country 'USA' -Phone '555-555-5555'

        Retrieves a specific account, passes information by pipeline. Updates specific account with provided parameters.
    .EXAMPLE
        (Get-TdpscAccount -ID 33625), (Get-TdpscAccount -ID 32746) | Set-TdpscAccount -City 'Anytown' -StateAbbr 'USA' -PostalCode '12345' -Country 'USA' -Phone '555-555-5555'

        Retrieves a multiple accounts, passes information by pipeline. Updates accounts with provided parameters.
    .EXAMPLE
        Get-TdpscAccount | Where-Object {$_.ID -eq 33625 -or $_.ID -eq 32746} | Set-TdpscAccount -City 'Anytown' -StateAbbr 'USA' -PostalCode '12345' -Country 'USA' -Phone '555-555-5555'

        Retrieves a multiple accounts, passes information by pipeline. Updates accounts with provided parameters.
    .INPUTS
        PSObject or TeamDynamix.Api.Accounts.Account
        You can pipe a PSObject or Account object that contains the account you would like to update.
    .OUTPUTS
        None or PSObject or System.Object[] or TeamDynamix.Api.Accounts.Account
        Set-TdpscAccount returns a System.Object[] object if multiple users are updated. If a single user is updated, Set-TdpscAccount returns a PSObject or TeamDynamix.Api.Accounts.Account object. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/Accounts#PUTapi/accounts/{id}
    #>

    [CmdletBinding(ConfirmImpact='Medium', SupportsShouldProcess=$true)]
    [OutputType([PSObject], [TeamDynamix.Api.Accounts.Account])]
    Param
    (
        [String]$Bearer,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Int32]$ID,

        [String]$Name,

        [Boolean]$IsActive,

        [String]$Address1,

        [String]$Address2,

        [String]$Address3,

        [String]$Address4,

        [String]$City,

        [String]$StateAbbr,

        [String]$PostalCode,

        [String]$Country,

        [String]$Phone,

        [String]$Fax,

        [String]$Url,

        [String]$Notes,

        [String]$Code,

        [Int32]$IndustryID,

        [String]$Domain
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

        if ($PSCmdlet.ShouldProcess("Account ID $($ID)", 'Edit Account'))
        {
            if ([String]::IsNullOrWhiteSpace($Bearer)) { $Bearer = Get-InternalBearer }

            if ($null -ne $_ -and ($_.GetType().FullName -eq 'TeamDynamix.Api.Accounts.Account' -or $_.GetType().FullName -eq 'System.Management.Automation.PSCustomObject'))
            {
                Write-Debug -Message 'Use existing account information from pipeline'
                $parms = @{
                    'String' = ConvertTo-JsonSerializeObject -InputObject $_
                    'Type'   = [TeamDynamix.Api.Accounts.Account]
                }

                $accountModify = ConvertTo-JsonDeserializeObject @parms
            }
            else
            {
                Write-Debug -Message 'Get all accounts, then filter based on ID'
                $accountModify = Get-TdpscAccount -Bearer $Bearer -ID $ID
            }

            if ($null -ne $accountModify)
            {
                # Web API currently does not perform PATCH on account information, it updates provided fields and clears remaining fields.
                Write-Debug -Message 'Copy parameter information to temporary [TeamDynamix.Api.Accounts.Account] object if provided'
                $accountModify.Name       = ($accountModify.Name,             $Name)[$PSBoundParameters.ContainsKey('Name')]
                $accountModify.IsActive   = ($accountModify.IsActive,     $IsActive)[$PSBoundParameters.ContainsKey('IsActive')]
                $accountModify.Address1   = ($accountModify.Address1,     $Address1)[$PSBoundParameters.ContainsKey('Address1')]
                $accountModify.Address2   = ($accountModify.Address2,     $Address2)[$PSBoundParameters.ContainsKey('Address2')]
                $accountModify.Address3   = ($accountModify.Address3,     $Address3)[$PSBoundParameters.ContainsKey('Address3')]
                $accountModify.Address4   = ($accountModify.Address4,     $Address4)[$PSBoundParameters.ContainsKey('Address4')]
                $accountModify.City       = ($accountModify.City,             $City)[$PSBoundParameters.ContainsKey('City')]
                $accountModify.StateAbbr  = ($accountModify.StateAbbr,   $StateAbbr)[$PSBoundParameters.ContainsKey('StateAbbr')]
                $accountModify.PostalCode = ($accountModify.PostalCode, $PostalCode)[$PSBoundParameters.ContainsKey('PostalCode')]
                $accountModify.Country    = ($accountModify.Country,       $Country)[$PSBoundParameters.ContainsKey('Country')]
                $accountModify.Phone      = ($accountModify.Phone,           $Phone)[$PSBoundParameters.ContainsKey('Phone')]
                $accountModify.Fax        = ($accountModify.Fax,               $Fax)[$PSBoundParameters.ContainsKey('Fax')]
                $accountModify.Url        = ($accountModify.Url,               $Url)[$PSBoundParameters.ContainsKey('Url')]
                $accountModify.Notes      = ($accountModify.Notes,           $Notes)[$PSBoundParameters.ContainsKey('Notes')]
                $accountModify.Code       = ($accountModify.Code,             $Code)[$PSBoundParameters.ContainsKey('Code')]
                $accountModify.IndustryID = ($accountModify.IndustryID, $IndustryID)[$PSBoundParameters.ContainsKey('IndustryID')]
                $accountModify.Domain     = ($accountModify.Domain,         $Domain)[$PSBoundParameters.ContainsKey('Domain')]

                $parms = @{
                    Body            = ConvertTo-JsonSerializeObject -InputObject $accountModify
                    ContentType     = 'application/json'
                    Headers         = @{
                                            Authorization = 'Bearer ' + $Bearer
                                        }
                    Method          = 'Put'
                    Uri             = (Get-TdpscApiBaseAddress) + "accounts/$($ID)"
                    UseBasicParsing = $true
                }

                Write-Debug -Message ($parms | Out-String)

                $request = Invoke-WebRequest @parms

                if ((Get-TdReturnApiType) -eq $true)
                {
                    ConvertTo-JsonDeserializeObject -String $request.Content -Type TeamDynamix.Api.Accounts.Account
                }
                else
                {
                    $request.Content | ConvertFrom-Json
                }
            }
            else
            {
                Write-Error -Message "Account ID $($ID) returned no information. Account may no longer be active and accessible through Web API."
            }
        }
    }
    End
    {
        Write-Debug -Message "[$($MyInvocation.MyCommand.Name)] complete"
    }
}

Export-ModuleMember -Function Get-TdpscAccount
Export-ModuleMember -Function New-TdpscAccount
Export-ModuleMember -Function Set-TdpscAccount
