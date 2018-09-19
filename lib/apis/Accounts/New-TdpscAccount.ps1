#Requires -Version 3

Set-StrictMode -Version 3

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
