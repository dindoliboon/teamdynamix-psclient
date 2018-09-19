#Requires -Version 3

Set-StrictMode -Version 3

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
