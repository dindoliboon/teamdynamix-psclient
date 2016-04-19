<#
    Contains methods for working with users and other individuals within the TeamDynamix people database.

    https://app.teamdynamix.com/TDWebApi/Home/section/People
#>

#Requires -Version 3

Set-StrictMode -Version 3

function Get-TdpscPerson
{
    <#
    .SYNOPSIS
        Gets a person from the system.
    .DESCRIPTION
        Use Get-TdpscPerson to return an individual person based on ID or supply account information to other tasks.
    .PARAMETER Bearer
        Bearer token received when logging in.
    .PARAMETER UID
        The user unique identifier.
    .EXAMPLE
        Get-TdpscPerson -UID 'ec57223c-980c-4d17-8133-d9553f49b519'

        Return the person matching the requested UID.
    .INPUTS
        String
        You can pipe a String that contains a bearer token.
    .OUTPUTS
        None or PSObject or TeamDynamix.Api.Users.User
        Get-TdpscAccount returns a PSObject or TeamDynamix.Api.Users.User object if a person is found. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/People#GETapi/people/{uid}
    #>

    [CmdletBinding()]
    [OutputType([PSObject], [TeamDynamix.Api.Users.User])]
    Param
    (
        [Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
		[String]$Bearer,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
		[String]$UID
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

        $parms = @{
            ContentType     = 'application/json'
            Headers         = @{
                                    Authorization = 'Bearer ' + $Bearer
                                }
            Method          = 'Get'
            Uri             = (Get-TdpscApiBaseAddress) + "people/$($UID)"
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
    End
    {
        Write-Debug -Message "[$($MyInvocation.MyCommand.Name)] complete"
    }
}

function Get-TdpscPersonFunctionalRole
{
    <#
    .SYNOPSIS
        Gets all functional roles for a particular user.
    .DESCRIPTION
        Use Get-TdpscPersonFunctionalRole to return all functional roles for the specified user.

        This action can only be performed by administrative accounts and not standard TeamDynamix users.

        Invocations of this method are rate-limited, with a restriction of 180 calls per IP every 60 seconds.
    .PARAMETER Bearer
        Bearer token received when logging in.
    .PARAMETER UID
        The user unique identifier.
    .EXAMPLE
        Get-TdpscPersonFunctionalRole -UID '313f362a-b885-4ea9-996a-6cc9c9eb039b'

        Return the roles matching the requested UID.
    .INPUTS
        String
        You can pipe a String that contains a user UID.
    .OUTPUTS
        None or TeamDynamix.Api.Roles.UserFunctionalRole or System.Object[]
        Get-TdpscPersonFunctionalRole returns a System.Object[] object if any functional roles are found. If Get-TdReturnApiType is true and only one functional role is found, the type is TeamDynamix.Api.Roles.UserFunctionalRole. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/People#GETapi/people/{uid}/functionalroles
    #>

    [CmdletBinding()]
    [OutputType([TeamDynamix.Api.Roles.UserFunctionalRole], [System.Object[]])]
    Param
    (
        [String]$Bearer,

        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
		[Guid]$UID
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

        $parms = @{
            ContentType     = 'application/json'
            Headers         = @{
                                    Authorization = 'Bearer ' + $Bearer
                                }
            Method          = 'Get'
            Uri             = (Get-TdpscApiBaseAddress) + "people/$($UID)/functionalroles"
            UseBasicParsing = $true
        }

        Write-Debug -Message ($parms | Out-String)

        $request = Invoke-WebRequest @parms

        if ((Get-TdReturnApiType) -eq $true)
        {
            ConvertTo-JsonDeserializeObject -String $request.Content -Type TeamDynamix.Api.Roles.UserFunctionalRole[]
        }
        else
        {
            $request.Content | ConvertFrom-Json
        }
    }
    End
    {
        Write-Debug -Message "[$($MyInvocation.MyCommand.Name)] complete"
    }
}

function Get-TdpscPersonGroup
{
    <#
    .SYNOPSIS
        Gets all groups for a particular user.
    .DESCRIPTION
        Use Get-TdpscPersonGroup to return all groups for the specified user.

        This action can only be performed by administrative accounts and not standard TeamDynamix users.

        Invocations of this method are rate-limited, with a restriction of 180 calls per IP every 60 seconds.
    .PARAMETER Bearer
        Bearer token received when logging in.
    .PARAMETER UID
        The user unique identifier.
    .EXAMPLE
        Get-TdpscPersonGroup -UID '313f362a-b885-4ea9-996a-6cc9c9eb039b'

        Return the groups matching the requested UID.
    .INPUTS
        String
        You can pipe a String that contains a user UID.
    .OUTPUTS
        None or TeamDynamix.Api.Users.UserGroup[] or System.Object[]
        Get-TdpscPersonGroup returns a System.Object[] object if any groups are found. If Get-TdReturnApiType is true and only one group is found, the type is TeamDynamix.Api.Users.UserGroup. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/People#GETapi/people/{uid}/groups
    #>

    [CmdletBinding()]
    [OutputType([TeamDynamix.Api.Users.UserGroup], [System.Object[]])]
    Param
    (
        [String]$Bearer,

        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
		[Guid]$UID
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

        $parms = @{
            ContentType     = 'application/json'
            Headers         = @{
                                    Authorization = 'Bearer ' + $Bearer
                                }
            Method          = 'Get'
            Uri             = (Get-TdpscApiBaseAddress) + "people/$($UID)/groups"
            UseBasicParsing = $true
        }

        Write-Debug -Message ($parms | Out-String)

        $request = Invoke-WebRequest @parms

        if ((Get-TdReturnApiType) -eq $true)
        {
            ConvertTo-JsonDeserializeObject -String $request.Content -Type TeamDynamix.Api.Roles.UserFunctionalRole[]
        }
        else
        {
            $request.Content | ConvertFrom-Json
        }
    }
    End
    {
        Write-Debug -Message "[$($MyInvocation.MyCommand.Name)] complete"
    }
}

function Get-TdpscPersonSearch
{
    <#
    .SYNOPSIS
        Gets a list of users.
    .DESCRIPTION
        Use Get-TdpscPersonSearch to return a collection of users.

        Does not return collection objects such as Applications, Permissions, Groups, or Custom Attributes. Use the singular GET to retrieve these collections for a singular user.

        This action requires access to the TDPeople application.

        Invocations of this method are rate-limited, with a restriction of 60 calls per IP every 60 seconds.

        If you are attempting to look up basic user information using a simple search string, consider using the Get-TdpscRestrictedPersonSearch method instead.
    .PARAMETER Bearer
        Bearer token received when logging in.
    .PARAMETER SearchText
        The search text to perform LIKE-based filtering on.
    .PARAMETER IsActive
        The active status to filter on.
    .PARAMETER IsEmployee
        The employee status to filter on.
    .PARAMETER AppName
        The name of the application to filter on. If specified, will only include users who have been granted access to this application.
    .PARAMETER AccountID
        The account ID to filter on. If specified, will only include users who list the account as their default.
    .PARAMETER MaxResults
        The maximum number of records to return.
    .EXAMPLE
        Get-TdpscPersonSearch -Bearer $Bearer -SearchText 'John Doe'
        
        Returns users matching search criteria.
    .INPUTS
        String
        You can pipe a String that contains a bearer token.
    .OUTPUTS
        None or PSObject or TeamDynamix.Api.Users.User or System.Object[]
        Get-TdpscPersonSearch returns a System.Object[] object if users are found. If Get-TdReturnApiType is true and only one user is found, the type is TeamDynamix.Api.Users.User. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/People#POSTapi/people/search
    #>

    [CmdletBinding()]
    [OutputType([TeamDynamix.Api.Users.User], [System.Object[]])]
    Param
    (
        [Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
		[String]$Bearer,

		[String]$SearchText,

		[System.Nullable[Boolean]]$IsActive = $null,

		[System.Nullable[Boolean]]$IsEmployee = $null,

		[String]$AppName,

		[System.Nullable[Int32]]$AccountID = $null,

		[System.Nullable[Int32]]$MaxResults = 25
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

        $search = New-Object -TypeName TeamDynamix.Api.Users.UserSearch
        $search.SearchText = $SearchText
        $search.IsActive   = $IsActive
        $search.IsEmployee = $IsEmployee
        $search.AppName    = $AppName
        $search.AccountID  = $AccountID
        $search.MaxResults = $MaxResults

        $parms = @{
            Body            = ConvertTo-JsonSerializeObject -InputObject $search
            ContentType     = 'application/json'
            Headers         = @{
                                    Authorization = 'Bearer ' + $Bearer
                                }
            Method          = 'Post'
            Uri             = (Get-TdpscApiBaseAddress) + 'people/search'
            UseBasicParsing = $true
        }

        Write-Debug -Message ($parms | Out-String)

        $request = Invoke-WebRequest @parms

        if ((Get-TdReturnApiType) -eq $true)
        {
            ConvertTo-JsonDeserializeObject -String $request.Content -Type TeamDynamix.Api.Users.User[]
        }
        else
        {
            $request.Content | ConvertFrom-Json
        }
    }
    End
    {
        Write-Debug -Message "[$($MyInvocation.MyCommand.Name)] complete"
    }
}

function Get-TdpscRestrictedPersonSearch
{
    <#
    .SYNOPSIS
        Performs a restricted lookup of TeamDynamix people.
    .DESCRIPTION
        Use Get-TdpscRestrictedPersonSearch to return a filtered set of TeamDynamix people.

        Will not return full user information for each matching user.

        Invocations of this method are rate-limited, with a restriction of 10 calls per IP every 1 second.
    .PARAMETER Bearer
        Bearer token received when logging in.
    .PARAMETER SearchText
        The searching text to use.
    .PARAMETER MaxResults
        The maximum number of results to return. Must be in the range 1-100, and will default to 50.
    .EXAMPLE
        Get-TdpscRestrictedPersonSearch -Bearer $Bearer -SearchText 'John Doe'

        Returns users matching search criteria.
    .INPUTS
        String
        You can pipe a String that contains a bearer token.
    .OUTPUTS
        None or PSObject or TeamDynamix.Api.Users.User or System.Object[]
        Get-TdpscRestrictedPersonSearch returns a System.Object[] object if users are found. If Get-TdReturnApiType is true and only one user is found, the type is TeamDynamix.Api.Users.User. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/People#GETapi/people/lookup?searchText={searchText}&maxResults={maxResults}
    #>

    [CmdletBinding()]
    [OutputType([PSObject])]
    Param
    (
        [Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
		[String]$Bearer,

		[String]$SearchText,

		[Int32]$MaxResults = 50
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

        $queryParms = @{
            searchText = $SearchText
            maxResults = $MaxResults
        }

        $query = ($queryParms.GetEnumerator() | Where-Object {
                [string]::IsNullOrEmpty($_.Value) -eq $false
            } | ForEach-Object {
                $_.Key + '=' + [System.Uri]::EscapeDataString($_.Value)
            }) -join '&'


        $parms = @{
            ContentType     = 'application/json'
            Headers         = @{
                                    Authorization = 'Bearer ' + $Bearer
                                }
            Method          = 'Get'
            Uri             = (Get-TdpscApiBaseAddress) + 'people/lookup{0}' -f ("?$query", '')[[string]::IsNullOrEmpty($query)]
            UseBasicParsing = $true
        }

        Write-Debug -Message ($parms | Out-String)

        $request = Invoke-WebRequest @parms

        if ((Get-TdReturnApiType) -eq $true)
        {
            ConvertTo-JsonDeserializeObject -String $request.Content -Type TeamDynamix.Api.Users.User[]
        }
        else
        {
            $request.Content | ConvertFrom-Json
        }
    }
    End
    {
        Write-Debug -Message "[$($MyInvocation.MyCommand.Name)] complete"
    }
}

function New-TdpscPerson
{
    <#
    .SYNOPSIS
        Creates a user in the system.
    .DESCRIPTION
        Use New-TdpscPerson to creates a user in the system and return an object representing that person.

        This action can only be performed by administrative accounts and not standard TeamDynamix users.

        Invocations of this method are rate-limited, with a restriction of 45 calls per IP every 60 seconds.
    .PARAMETER Bearer
        Bearer token received when logging in. If null or empty, value is obtained by Get-InternalBearer.
    .PARAMETER Password
        The password of the new user.
    .PARAMETER UserName
        The username of the user.
    .PARAMETER DesktopID
        The desktop ID of the desktop to associate with the new user.
    .PARAMETER UID
        The ID of the user.
    .PARAMETER BEID
        The BEID of the user.
    .PARAMETER BEIDInt
        The integer-based BEID of the user.
    .PARAMETER IsActive
        Gets or sets a value indicating whether this user is active.
    .PARAMETER FullName
        The full name of the user.
    .PARAMETER FirstName
        The first name of the user.
    .PARAMETER LastName
        The last name of the user.
    .PARAMETER MiddleName
        The middle name of the user.
    .PARAMETER Birthday
        The user's birthday.
    .PARAMETER Salutation
        The salutation of the user.
    .PARAMETER Nickname
        The nickname of the user.
    .PARAMETER DefaultAccountID
        The ID of the default account for this user.
    .PARAMETER DefaultAccountName
        The name of the default account for this user.
    .PARAMETER PrimaryEmail
        The primary email address for this user.
    .PARAMETER AlternateEmail
        The alternate email.
    .PARAMETER ExternalID
        The organizational ID for this user.
    .PARAMETER AlternateID
        The alternate ID for this user.
    .PARAMETER Applications
        The system-defined (i.e. non-Platform) applications for this user.
    .PARAMETER SecurityRoleName
        The name of the user's global security role.
    .PARAMETER SecurityRoleID
        The ID of the user's global security role.
    .PARAMETER Permissions
        The global security role permissions for this user.
    .PARAMETER OrgApplications
        The organizationally-defined (i.e. Platform) applications for this user.
    .PARAMETER GroupIDs
        The IDs of the groups to which this user belongs.
    .PARAMETER ReferenceID
        The integer reference ID for this user.
    .PARAMETER AlertEmail
        The alert email address for the user. System notifications will be sent to this E-Mail address.
    .PARAMETER Company
        The name of the user's company.
    .PARAMETER Title
        The title.
    .PARAMETER HomePhone
        The home phone.
    .PARAMETER PrimaryPhone
        The primary phone number for the user. This is a value such as "Work" or "Mobile".
    .PARAMETER WorkPhone
        The work phone.
    .PARAMETER Pager
        The pager.
    .PARAMETER OtherPhone
        The other phone.
    .PARAMETER MobilePhone
        The mobile phone.
    .PARAMETER Fax
        The fax.
    .PARAMETER DefaultPriorityID
        The default priority ID
    .PARAMETER DefaultPriorityName
        The default priority name.
    .PARAMETER AboutMe
        The about me.
    .PARAMETER WorkAddress
        The work address.
    .PARAMETER WorkCity
        The work city.
    .PARAMETER WorkState
        The state of the work.
    .PARAMETER WorkZip
        The work zip.
    .PARAMETER WorkCountry
        The work country.
    .PARAMETER HomeAddress
        The home address.
    .PARAMETER HomeCity
        The home city.
    .PARAMETER HomeState
        The state of the home.
    .PARAMETER HomeZip
        The home zip code.
    .PARAMETER HomeCountry
        The home country.
    .PARAMETER DefaultRate
        The default billing rate.
    .PARAMETER CostRate
        The cost rate.
    .PARAMETER IsEmployee
        The value indicating whether this user is an employee.
    .PARAMETER WorkableHours
        The number of workable hours in a work day for this user. This only applies to Users, not Customers. Customers will always have this set to 0.
    .PARAMETER IsCapacityManaged
        The value indicating whether this user's capacity is managed, meaning they can have capacity and will appear on capacity/availability reports. This only applies to Users, not Customers. Customers will always have this set to false.
    .PARAMETER ReportTimeAfterDate
        The date the user should start reporting time on after. This also governs capacity calculations.
    .PARAMETER EndDate
        The date the user is no longer available for scheduling and no longer required to log time after.
    .PARAMETER ShouldReportTime
        The value indicating whether the user should report time.
    .PARAMETER ReportsToUID
        The unique identifier of the user this user reports to.
    .PARAMETER ReportsToFullName
        The full name of the user this user reports to.
    .PARAMETER ResourcePoolID
        The ID of the resource pool this user belongs to.
    .PARAMETER ResourcePoolName
        The name of the resource pool.
    .PARAMETER TZID
        The ID of the time zone the user is in.
    .PARAMETER TZName
        The name of the time zone the user is in.
    .PARAMETER TypeID
        Type of the user.
    .PARAMETER AuthenticationUserName
        The authentication username of the new user. This username is what will be used when authenticating rather than the standard username field. This field only applies to non-TeamDynamix authentication types. This value should be unique across all username and authentication usernames in your organization. If the provided value is not unique, it will be ignored.
    .PARAMETER AuthenticationProviderID
        The authentication provider this user will use to authenticate by its ID. Leave this value blank to specify TeamDynamix or when using SSO authentication. This value can be obtained from the Admin application Authentication section by one of your organization's administrators who has access to modify authentication settings. If an invalid value is provided, this will use the default authentication provider for the organization.
    .PARAMETER Attributes
        The custom person attributes.
    .PARAMETER Gender
        The person's gender.
    .PARAMETER IMProvider
        The instand messenger provider for the person.
    .PARAMETER IMHandle
        The instant messenger username (or "handle") for the person.
    .EXAMPLE
        New-TdpscPerson -Password 'not-very-secure' -UserName 'MyUser@example.com' -AuthenticationUserName 'MyUser@example.com' -FirstName 'John' -LastName 'Doe' -PrimaryEmail 'MyUser@example.com' -TZID 2 -TypeID 1 -AlertEmail 'MyUser@example.com' -Company 'Awesome Company' -WorkZip '12345' -SecurityRoleID '8ab0f7f5-6e34-4cfa-a75a-ad2a2fc6bc9c'

        Creates a new person with the provided parameters.
    .EXAMPLE
        Get-TdpscPerson -UID 'e305d99a-b101-e611-80ce-000d3a133f86' | New-TdpscPerson -Password 'not-very-secure' -UserName 'MyUser2@example.com' -AuthenticationUserName 'MyUser2@example.com' -FirstName 'John' -LastName 'Doe' -PrimaryEmail 'MyUser2@example.com' -AlertEmail 'MyUser2@example.com'

        Retrieves a specific person, passes information by pipeline. Creates a new person, using the pipeline information as a template.
    .EXAMPLE
        $person = New-Object -TypeName PSObject -Property @{
            Password               = 'not-very-secure'
            UserName               = 'MyUser@example.com'
            AuthenticationUserName = 'MyUser@example.com'
            FirstName              = 'John'
            LastName               = 'Doe'
            PrimaryEmail           = 'MyUser@example.com'
            TZID                   = 2
            TypeID                 = 1
            AlertEmail             = 'MyUser@example.com'
            Company                = 'Awesome Company'
            WorkZip                = '12345'
            SecurityRoleID         = '8ab0f7f5-6e34-4cfa-a75a-ad2a2fc6bc9c'
        }
        $person | New-TdpscPerson

        Create a new person using information from a PSObject object, passed by pipeline.
    .EXAMPLE
        $person = New-Object -TypeName TeamDynamix.Api.Users.NewUser
        $person.Password               = 'not-very-secure'
        $person.UserName               = 'MyUser@example.com'
        $person.AuthenticationUserName = 'MyUser@example.com'
        $person.FirstName              = 'John'
        $person.LastName               = 'Doe'
        $person.PrimaryEmail           = 'MyUser@example.com'
        $person.TZID                   = 2
        $person.TypeID                 = 1
        $person.AlertEmail             = 'MyUser@example.com'
        $person.Company                = 'Awesome Company'
        $person.WorkZip                = '12345'
        $person.SecurityRoleID         = '8ab0f7f5-6e34-4cfa-a75a-ad2a2fc6bc9c'
        $person | New-TdpscPerson

        Create a new person using information from a NewUser object, passed by pipeline.
    .INPUTS
        PSObject or TeamDynamix.Api.Users.User or TeamDynamix.Api.Users.NewUser
        You can pipe a PSObject or TeamDynamix.Api.Users.User or TeamDynamix.Api.Users.NewUser object that contains the information of the new person.
    .OUTPUTS
        None or PSObject or TeamDynamix.Api.Users.User
        New-TdpscPerson returns a PSObject or TeamDynamix.Api.Users.User object that contains the newly created person. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/People#POSTapi/people
    #>

    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([PSObject], [TeamDynamix.Api.Users.User])]
    Param
    (
		[String]$Bearer,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [String]$Password,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [String]$UserName,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Guid]$DesktopID,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Guid]$UID,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Guid]$BEID,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Int32]$BEIDInt,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$FullName,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [String]$FirstName,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [String]$LastName,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$MiddleName,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [DateTime]$Birthday,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$Salutation,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$Nickname,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Int32]$DefaultAccountID,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$DefaultAccountName,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [String]$PrimaryEmail,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$AlternateEmail,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$ExternalID,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$AlternateID,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String[]]$Applications,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$SecurityRoleName,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [String]$SecurityRoleID,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String[]]$Permissions,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [TeamDynamix.Api.Apps.UserApplication[]]$OrgApplications,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Int32[]]$GroupIDs,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Int32]$ReferenceID,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [String]$AlertEmail,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [String]$Company,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$Title,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$HomePhone,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$PrimaryPhone,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$WorkPhone,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$Pager,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$OtherPhone,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$MobilePhone,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$Fax,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Int32]$DefaultPriorityID,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$DefaultPriorityName,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$AboutMe,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$WorkAddress,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$WorkCity,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$WorkState,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [String]$WorkZip,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$WorkCountry,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$HomeAddress,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$HomeCity,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$HomeState,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$HomeZip,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$HomeCountry,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Double]$DefaultRate,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Double]$CostRate,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Boolean]$IsEmployee,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Double]$WorkableHours,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Boolean]$IsCapacityManaged,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [DateTime]$ReportTimeAfterDate,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [DateTime]$EndDate,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Boolean]$ShouldReportTime,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$ReportsToUID,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$ReportsToFullName,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Int32]$ResourcePoolID,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$ResourcePoolName,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Int32]$TZID,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$TZName,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [TeamDynamix.Api.Users.UserType]$TypeID,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$AuthenticationUserName,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [System.Nullable[Int32]]$AuthenticationProviderID,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [TeamDynamix.Api.CustomAttributes.CustomAttribute[]]$Attributes,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [TeamDynamix.Api.Users.UserGender]$Gender,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$IMProvider,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$IMHandle
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

        if ($PSCmdlet.ShouldProcess("Account Name $($FirstName) $($LastName)", 'Create Account'))
        {
            if ([String]::IsNullOrWhiteSpace($Bearer)) { $Bearer = Get-InternalBearer }

            if ($null -ne $_ -and ($_.GetType().FullName -eq 'TeamDynamix.Api.Users.NewUser' -or $_.GetType().FullName -eq 'TeamDynamix.Api.Users.User' -or $_.GetType().FullName -eq 'System.Management.Automation.PSCustomObject'))
            {
                Write-Debug -Message 'Use existing account information from pipeline'
                $parms = @{
                    'String' = ConvertTo-JsonSerializeObject -InputObject $_
                    'Type'   = [TeamDynamix.Api.Users.NewUser]
                }

                $newPerson = ConvertTo-JsonDeserializeObject @parms
            }
            else
            {
                $newPerson = New-Object -TypeName TeamDynamix.Api.Users.NewUser
            }

            $newPerson.Password                 = ($newPerson.Password, $Password)[$PSBoundParameters.ContainsKey('Password')]
            $newPerson.UserName                 = ($newPerson.UserName, $UserName)[$PSBoundParameters.ContainsKey('UserName')]
            $newPerson.DesktopID                = ($newPerson.DesktopID, $DesktopID)[$PSBoundParameters.ContainsKey('DesktopID')]
            $newPerson.UID                      = ($newPerson.UID, $UID)[$PSBoundParameters.ContainsKey('UID')]
            $newPerson.BEID                     = ($newPerson.BEID, $BEID)[$PSBoundParameters.ContainsKey('BEID')]
            $newPerson.BEIDInt                  = ($newPerson.BEIDInt, $BEIDInt)[$PSBoundParameters.ContainsKey('BEIDInt')]
            $newPerson.IsActive                 = $true
            $newPerson.FullName                 = ($newPerson.FullName, $FullName)[$PSBoundParameters.ContainsKey('FullName')]
            $newPerson.FirstName                = ($newPerson.FirstName, $FirstName)[$PSBoundParameters.ContainsKey('FirstName')]
            $newPerson.LastName                 = ($newPerson.LastName, $LastName)[$PSBoundParameters.ContainsKey('LastName')]
            $newPerson.MiddleName               = ($newPerson.MiddleName, $MiddleName)[$PSBoundParameters.ContainsKey('MiddleName')]
            $newPerson.Birthday                 = ($newPerson.Birthday, $Birthday)[$PSBoundParameters.ContainsKey('Birthday')]
            $newPerson.Salutation               = ($newPerson.Salutation, $Salutation)[$PSBoundParameters.ContainsKey('Salutation')]
            $newPerson.Nickname                 = ($newPerson.Nickname, $Nickname)[$PSBoundParameters.ContainsKey('Nickname')]
            $newPerson.DefaultAccountID         = ($newPerson.DefaultAccountID, $DefaultAccountID)[$PSBoundParameters.ContainsKey('DefaultAccountID')]
            $newPerson.DefaultAccountName       = ($newPerson.DefaultAccountName, $DefaultAccountName)[$PSBoundParameters.ContainsKey('DefaultAccountName')]
            $newPerson.PrimaryEmail             = ($newPerson.PrimaryEmail, $PrimaryEmail)[$PSBoundParameters.ContainsKey('PrimaryEmail')]
            $newPerson.AlternateEmail           = ($newPerson.AlternateEmail, $AlternateEmail)[$PSBoundParameters.ContainsKey('AlternateEmail')]
            $newPerson.ExternalID               = ($newPerson.ExternalID, $ExternalID)[$PSBoundParameters.ContainsKey('ExternalID')]
            $newPerson.AlternateID              = ($newPerson.AlternateID, $AlternateID)[$PSBoundParameters.ContainsKey('AlternateID')]
            $newPerson.Applications             = ($newPerson.Applications, $Applications)[$PSBoundParameters.ContainsKey('Applications')]
            $newPerson.SecurityRoleName         = ($newPerson.SecurityRoleName, $SecurityRoleName)[$PSBoundParameters.ContainsKey('SecurityRoleName')]
            $newPerson.SecurityRoleID           = ($newPerson.SecurityRoleID, $SecurityRoleID)[$PSBoundParameters.ContainsKey('SecurityRoleID')]
            $newPerson.Permissions              = ($newPerson.Permissions, $Permissions)[$PSBoundParameters.ContainsKey('Permissions')]
            $newPerson.OrgApplications          = ($newPerson.OrgApplications, $OrgApplications)[$PSBoundParameters.ContainsKey('OrgApplications')]
            $newPerson.GroupIDs                 = ($newPerson.GroupIDs, $GroupIDs)[$PSBoundParameters.ContainsKey('GroupIDs')]
            $newPerson.ReferenceID              = ($newPerson.ReferenceID, $ReferenceID)[$PSBoundParameters.ContainsKey('ReferenceID')]
            $newPerson.AlertEmail               = ($newPerson.AlertEmail, $AlertEmail)[$PSBoundParameters.ContainsKey('AlertEmail')]
            $newPerson.Company                  = ($newPerson.Company, $Company)[$PSBoundParameters.ContainsKey('Company')]
            $newPerson.Title                    = ($newPerson.Title, $Title)[$PSBoundParameters.ContainsKey('Title')]
            $newPerson.HomePhone                = ($newPerson.HomePhone, $HomePhone)[$PSBoundParameters.ContainsKey('HomePhone')]
            $newPerson.PrimaryPhone             = ($newPerson.PrimaryPhone, $PrimaryPhone)[$PSBoundParameters.ContainsKey('PrimaryPhone')]
            $newPerson.WorkPhone                = ($newPerson.WorkPhone, $WorkPhone)[$PSBoundParameters.ContainsKey('WorkPhone')]
            $newPerson.Pager                    = ($newPerson.Pager, $Pager)[$PSBoundParameters.ContainsKey('Pager')]
            $newPerson.OtherPhone               = ($newPerson.OtherPhone, $OtherPhone)[$PSBoundParameters.ContainsKey('OtherPhone')]
            $newPerson.MobilePhone              = ($newPerson.MobilePhone, $MobilePhone)[$PSBoundParameters.ContainsKey('MobilePhone')]
            $newPerson.Fax                      = ($newPerson.Fax, $Fax)[$PSBoundParameters.ContainsKey('Fax')]
            $newPerson.DefaultPriorityID        = ($newPerson.DefaultPriorityID, $DefaultPriorityID)[$PSBoundParameters.ContainsKey('DefaultPriorityID')]
            $newPerson.DefaultPriorityName      = ($newPerson.DefaultPriorityName, $DefaultPriorityName)[$PSBoundParameters.ContainsKey('DefaultPriorityName')]
            $newPerson.AboutMe                  = ($newPerson.AboutMe, $AboutMe)[$PSBoundParameters.ContainsKey('AboutMe')]
            $newPerson.WorkAddress              = ($newPerson.WorkAddress, $WorkAddress)[$PSBoundParameters.ContainsKey('WorkAddress')]
            $newPerson.WorkCity                 = ($newPerson.WorkCity, $WorkCity)[$PSBoundParameters.ContainsKey('WorkCity')]
            $newPerson.WorkState                = ($newPerson.WorkState, $WorkState)[$PSBoundParameters.ContainsKey('WorkState')]
            $newPerson.WorkZip                  = ($newPerson.WorkZip, $WorkZip)[$PSBoundParameters.ContainsKey('WorkZip')]
            $newPerson.WorkCountry              = ($newPerson.WorkCountry, $WorkCountry)[$PSBoundParameters.ContainsKey('WorkCountry')]
            $newPerson.HomeAddress              = ($newPerson.HomeAddress, $HomeAddress)[$PSBoundParameters.ContainsKey('HomeAddress')]
            $newPerson.HomeCity                 = ($newPerson.HomeCity, $HomeCity)[$PSBoundParameters.ContainsKey('HomeCity')]
            $newPerson.HomeState                = ($newPerson.HomeState, $HomeState)[$PSBoundParameters.ContainsKey('HomeState')]
            $newPerson.HomeZip                  = ($newPerson.HomeZip, $HomeZip)[$PSBoundParameters.ContainsKey('HomeZip')]
            $newPerson.HomeCountry              = ($newPerson.HomeCountry, $HomeCountry)[$PSBoundParameters.ContainsKey('HomeCountry')]
            $newPerson.DefaultRate              = ($newPerson.DefaultRate, $DefaultRate)[$PSBoundParameters.ContainsKey('DefaultRate')]
            $newPerson.CostRate                 = ($newPerson.CostRate, $CostRate)[$PSBoundParameters.ContainsKey('CostRate')]
            $newPerson.IsEmployee               = ($newPerson.IsEmployee, $IsEmployee)[$PSBoundParameters.ContainsKey('IsEmployee')]
            $newPerson.WorkableHours            = ($newPerson.WorkableHours, $WorkableHours)[$PSBoundParameters.ContainsKey('WorkableHours')]
            $newPerson.IsCapacityManaged        = ($newPerson.IsCapacityManaged, $IsCapacityManaged)[$PSBoundParameters.ContainsKey('IsCapacityManaged')]
            $newPerson.ReportTimeAfterDate      = ($newPerson.ReportTimeAfterDate, $ReportTimeAfterDate)[$PSBoundParameters.ContainsKey('ReportTimeAfterDate')]
            $newPerson.EndDate                  = ($newPerson.EndDate, $EndDate)[$PSBoundParameters.ContainsKey('EndDate')]
            $newPerson.ShouldReportTime         = ($newPerson.ShouldReportTime, $ShouldReportTime)[$PSBoundParameters.ContainsKey('ShouldReportTime')]
            $newPerson.ReportsToUID             = ($newPerson.ReportsToUID, $ReportsToUID)[$PSBoundParameters.ContainsKey('ReportsToUID')]
            $newPerson.ReportsToFullName        = ($newPerson.ReportsToFullName, $ReportsToFullName)[$PSBoundParameters.ContainsKey('ReportsToFullName')]
            $newPerson.ResourcePoolID           = ($newPerson.ResourcePoolID, $ResourcePoolID)[$PSBoundParameters.ContainsKey('ResourcePoolID')]
            $newPerson.ResourcePoolName         = ($newPerson.ResourcePoolName, $ResourcePoolName)[$PSBoundParameters.ContainsKey('ResourcePoolName')]
            $newPerson.TZID                     = ($newPerson.TZID, $TZID)[$PSBoundParameters.ContainsKey('TZID')]
            $newPerson.TZName                   = ($newPerson.TZName, $TZName)[$PSBoundParameters.ContainsKey('TZName')]
            $newPerson.TypeID                   = ($newPerson.TypeID, $TypeID)[$PSBoundParameters.ContainsKey('TypeID')]
            $newPerson.AuthenticationUserName   = ($newPerson.AuthenticationUserName, $AuthenticationUserName)[$PSBoundParameters.ContainsKey('AuthenticationUserName')]
            $newPerson.AuthenticationProviderID = ($newPerson.AuthenticationProviderID, $AuthenticationProviderID)[$PSBoundParameters.ContainsKey('AuthenticationProviderID')]
            $newPerson.Attributes               = ($newPerson.Attributes, $Attributes)[$PSBoundParameters.ContainsKey('Attributes')]
            $newPerson.Gender                   = ($newPerson.Gender, $Gender)[$PSBoundParameters.ContainsKey('Gender')]
            $newPerson.IMProvider               = ($newPerson.IMProvider, $IMProvider)[$PSBoundParameters.ContainsKey('IMProvider')]
            $newPerson.IMHandle                 = ($newPerson.IMHandle, $IMHandle)[$PSBoundParameters.ContainsKey('IMHandle')]

            $parms = @{
                Body            = ConvertTo-JsonSerializeObject -InputObject $newPerson
                ContentType     = 'application/json'
                Headers         = @{
                                        Authorization = 'Bearer ' + $Bearer
                                    }
                Method          = 'Post'
                Uri             = (Get-TdpscApiBaseAddress) + 'people'
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

function New-TdpscPersonImport
{
    <#
    .SYNOPSIS
        Upload file for People Import process.
    .DESCRIPTION
        Use New-TdpscPersonImport to upload/update multiple People objects.

        Accepts a file, stores that file on disk, and places an entry into the database to indicate to the import file processor to pick up the file and run a People Import on it.

        This action accepts an uploaded file as part of the form's submission.

        For information on how to structure calls with files, see the Submitting Files page.

        This action can only be performed by administrative accounts and not standard TeamDynamix users.

        Invocations of this method are rate-limited, with a restriction of 10 calls per IP every 60 seconds.

        Requirements:
            The file must be in .xlsx format
            The file must have a header row with supported TeamDynamix fields as column names. Download the template file using the instructions below for more details.
            This process can be used to:
            Update existing customer and user records
            Create new customer records if no existing customer is found and the user type is Customer
            Create new users if no existing user is found and the user type is User
            This process will not:
            Convert existing Customer records to User records or vice-versa
            Activate or deactivate users (this should be done by calling the POST api/people/{uid} method)
            Change system application access for records being updated. Applications only apply for records to be created.
            Change platform application access for records, either on creation or updating.
            Updating Existing Records: 
            The following matching logic is used to determine if a records should be udpated or created.
            Username - If there already exists one or more people, regardless of active status, with the same TeamDynamix username as a row that is being imported, those records will be updated from the spreadsheet. This field will only be used for the purposes of matching. TeamDynamix username fields will not be updated as part of this process.
            Authentication Username - If there already exists one or more people, regardless of active status, with the same TeamDynamix authentication username as a row that is being imported, those records will be updated from the spreadsheet. This is the Auth Username specified for the user in the TDAdmin application. This field will only be used for the purposes of matching. TeamDynamix authentication username fields will not be updated as part of this process.
            Organizational ID - If there already exists one or more people, regardless of active status, with the same organizational ID as a row that is being imported, those records will be updated from the spreadsheet.
            Primary Email Address - If there already exists one or more people, regardless of active status, with the same primary email as a row that is being imported, those records will be updated from the spreadsheet.
            User organizational IDs and primary email addresses will be updated as part of this process as long as they are not the fields which records are matched on.

        Creating New Records:
            When creating records, the default is to create a Customer. If you do not include the User Type column and specify a user type of User, Customer records will be created.

        Not Mapping Values vs. Clearing Values :
            It is important to note that this process will only attempt to modify values for fields which are included in the import sheet and can be mapped to a TeamDynamix field. For instance, if you do not provide a column for a user's home phone, that value will not be mapped and thus will not be changed in any way. If you want to clear values, be sure that you provide a column for the field you want to clear and leave the cell values blank.

        Schedule:
            Calls to this endpoint are not processed in real-time. All import jobs are run in a batch process overnight.

        Download the Template File:
            See this TeamDynamix Knowledge Base article for a template upload file with the supported columns. The template will contain all necessary instructions for how to obtain column values for each column.
    .PARAMETER Bearer
        Bearer token received when logging in. If null or empty, value is obtained by Get-InternalBearer.
    .PARAMETER Path
        Location to the XLSX file.
    .EXAMPLE
        New-TdpscPersonImport -Bearer $Bearer -Path 'V:\MyTdFile.xlsx'

        Upload file for Person import process.
    .INPUTS
        String
        You can pipe a String that contains a bearer token.
    .OUTPUTS
        None or String
        A response message indicating if the operation was successful (OK) or not.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/People#POSTapi/people/import

        Submitting Files
        https://app.teamdynamix.com/TDWebApi/Home/AboutFileSubmission

        How to use the TDWebApi Import service to sync users between your organization and TeamDynamix
        https://solutions.teamdynamix.com/TDClient/KB/ArticleDet?ID=4191
    #>

    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([String])]
    Param
    (
        [Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
		[String]$Bearer,

        [Parameter(Mandatory=$true)]
		[String]$Path
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

        if ($PSCmdlet.ShouldProcess("Upload People file $($Path)", 'Upload File'))
        {
            if ([String]::IsNullOrWhiteSpace($Bearer)) { $Bearer = Get-InternalBearer }

            $parmsData = @{
                Path                        = $Path
                EncodingName                = 'iso-8859-1'
                Boundary                    = [System.Guid]::NewGuid().ToString()
                ContentDispositionFieldName = 'fieldNameHere'
                ContentDispositionFileName  = 'PeopleImportTemplate.xlsx'
                ContentType                 = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
            }

            $parms = @{
                Body            = Get-UploadBoundaryEncodedByte @parmsData
                ContentType     = "multipart/form-data; boundary=`"$($parmsData.Boundary)`""
                Headers         = @{
                                        Authorization = 'Bearer ' + $Bearer
                                    }
                Method          = 'Post'
                Uri             = (Get-TdpscApiBaseAddress) + 'people/import'
                UseBasicParsing = $true
            }

            Write-Debug -Message ($parms | Out-String)

            $request = Invoke-WebRequest @parms

            $request.StatusDescription
        }
    }
    End
    {
        Write-Debug -Message "[$($MyInvocation.MyCommand.Name)] complete"
    }
}

function Remove-TdpscPersonFunctionalRole
{
    <#
    .SYNOPSIS
        Removes the user from a functional role.
    .DESCRIPTION
        Use Remove-TdpscPersonFunctionalRole to removes the user from a functional role.

        This action can only be performed by administrative accounts and not standard TeamDynamix users.

        Invocations of this method are rate-limited, with a restriction of 180 calls per IP every 60 seconds.
    .PARAMETER Bearer
        Bearer token received when logging in.
    .PARAMETER UID
        The user unique identifier.
    .PARAMETER RoleID
        The functional role ID.
    .EXAMPLE
        Remove-TdpscPersonFunctionalRole -UID '313f362a-b885-4ea9-996a-6cc9c9eb039b' -RoleID 12

        Remove the user from the specified role.
    .INPUTS
        None
        You cannot pipe objects to this cmdlet.
    .OUTPUTS
        None or String
        Remove-TdpscPersonFunctionalRole returns a response message indicating if the operation was successful (OK) or not. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/People#DELETEapi/people/{uid}/functionalroles/{roleId}
    #>

    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([String])]
    Param
    (
        [String]$Bearer,

        [Parameter(Mandatory=$true)]
		[Guid]$UID,

        [Parameter(Mandatory=$true)]
		[Int32]$RoleID
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

        if ($PSCmdlet.ShouldProcess("Role ID $($RoleID) from UID $($UID)", 'Remove User From Functional Role'))
        {
            if ([String]::IsNullOrWhiteSpace($Bearer)) { $Bearer = Get-InternalBearer }

            $parms = @{
                ContentType     = 'application/json'
                Headers         = @{
                                        Authorization = 'Bearer ' + $Bearer
                                    }
                Method          = 'Delete'
                Uri             = (Get-TdpscApiBaseAddress) + "people/$($UID)/functionalroles/$($RoleID)"
                UseBasicParsing = $true
            }

            Write-Debug -Message ($parms | Out-String)

            $request = Invoke-WebRequest @parms

            $request.StatusDescription
        }
    }
    End
    {
        Write-Debug -Message "[$($MyInvocation.MyCommand.Name)] complete"
    }
}

function Remove-TdpscPersonGroup
{
    <#
    .SYNOPSIS
        Removes the user from a group.
    .DESCRIPTION
        Use Remove-TdpscPersonGroup to removes the user from a group.

        This action can only be performed by administrative accounts and not standard TeamDynamix users.

        Invocations of this method are rate-limited, with a restriction of 180 calls per IP every 60 seconds.
    .PARAMETER Bearer
        Bearer token received when logging in.
    .PARAMETER UID
        The user unique identifier.
    .PARAMETER GroupID
        The group ID.
    .EXAMPLE
        Remove-TdpscPersonGroup -UID '313f362a-b885-4ea9-996a-6cc9c9eb039b' -GroupID 12

        Remove the user from the specified group.
    .INPUTS
        None
        You cannot pipe objects to this cmdlet.
    .OUTPUTS
        None or String
        Remove-TdpscPersonGroup returns a response message indicating if the operation was successful (OK) or not. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/People#DELETEapi/people/{uid}/groups/{groupID}
    #>

    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([String])]
    Param
    (
        [String]$Bearer,

        [Parameter(Mandatory=$true)]
		[Guid]$UID,

        [Parameter(Mandatory=$true)]
		[Int32]$GroupID
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

        if ($PSCmdlet.ShouldProcess("Group ID $($GroupID) from UID $($UID)", 'Remove User From Group'))
        {
            if ([String]::IsNullOrWhiteSpace($Bearer)) { $Bearer = Get-InternalBearer }

            $parms = @{
                ContentType     = 'application/json'
                Headers         = @{
                                        Authorization = 'Bearer ' + $Bearer
                                    }
                Method          = 'Delete'
                Uri             = (Get-TdpscApiBaseAddress) + "people/$($UID)/groups/$($GroupID)"
                UseBasicParsing = $true
            }

            Write-Debug -Message ($parms | Out-String)

            $request = Invoke-WebRequest @parms

            $request.StatusDescription
        }
    }
    End
    {
        Write-Debug -Message "[$($MyInvocation.MyCommand.Name)] complete"
    }
}

function Set-TdpscPerson
{
    <#
    .SYNOPSIS
        Updates a person entry for the user with the specified identifier with a set of new values.
    .DESCRIPTION
        Use Set-TdpscPerson to update a user in the system and return an object representing that person.

        This action can only be performed by administrative accounts and not standard TeamDynamix users.

        Invocations of this method are rate-limited, with a restriction of 45 calls per IP every 60 seconds.

        You will not be able to change your password, change user's organization, or change user type using this method.
    .PARAMETER Bearer
        Bearer token received when logging in.
    .PARAMETER Person
        New values.
    .PARAMETER UID
        The ID of the user.
    .PARAMETER IsActive
        Value indicating whether this user is active.
    .PARAMETER FirstName
        The first name of the user.
    .PARAMETER LastName
        The last name of the user.
    .PARAMETER MiddleName
        The middle name of the user.
    .PARAMETER Birthday
        The user's birthday.
    .PARAMETER Salutation
        The salutation of the user.
    .PARAMETER Nickname
        The nickname of the user.
    .PARAMETER DefaultAccountID
        The ID of the default account for this user.
    .PARAMETER PrimaryEmail
        The primary email address for this user.
    .PARAMETER AlternateEmail
        The alternate email.
    .PARAMETER ExternalID
        The organizational ID for this user.
    .PARAMETER AlternateID
        The alternate ID for this user.
    .PARAMETER Applications
        The system-defined (i.e. non-Platform) applications for this user.
    .PARAMETER SecurityRoleID
        The ID of the user's global security role.
    .PARAMETER AlertEmail
        The alert email address for the user. System notifications will be sent to this E-Mail address.
    .PARAMETER Company
        The name of the user's company.
    .PARAMETER Title
        The title.
    .PARAMETER HomePhone
        The home phone.
    .PARAMETER PrimaryPhone
        The primary phone number for the user. This is a value such as "Work" or "Mobile".
    .PARAMETER WorkPhone
        The work phone.
    .PARAMETER Pager
        The pager.
    .PARAMETER OtherPhone
        The other phone.
    .PARAMETER MobilePhone
        The mobile phone.
    .PARAMETER Fax
        The fax.
    .PARAMETER DefaultPriorityID
        The default priority ID
    .PARAMETER AboutMe
        The about me.
    .PARAMETER WorkAddress
        The work address.
    .PARAMETER WorkCity
        The work city.
    .PARAMETER WorkState
        The state of the work.
    .PARAMETER WorkZip
        The work zip.
    .PARAMETER WorkCountry
        The work country.
    .PARAMETER HomeAddress
        The home address.
    .PARAMETER HomeCity
        The home city.
    .PARAMETER HomeState
        The state of the home.
    .PARAMETER HomeZip
        The home zip code.
    .PARAMETER HomeCountry
        The home country.
    .PARAMETER DefaultRate
        The default billing rate.
    .PARAMETER CostRate
        The cost rate.
    .PARAMETER IsEmployee
        Value indicating whether this user is an employee.
    .PARAMETER WorkableHours
        The number of workable hours in a work day for this user. This only applies to Users, not Customers. Customers will always have this set to 0.
    .PARAMETER IsCapacityManaged
        Value indicating whether this user's capacity is managed, meaning they can have capacity and will appear on capacity/availability reports. This only applies to Users, not Customers. Customers will always have this set to false.
    .PARAMETER ReportTimeAfterDate
        The date the user should start reporting time on after. This also governs capacity calculations.
    .PARAMETER EndDate
        The date the user is no longer available for scheduling and no longer required to log time after.
    .PARAMETER ShouldReportTime
        Value indicating whether the user should report time.
    .PARAMETER ReportsToUID
        The unique identifier of the user this user reports to.
    .PARAMETER ResourcePoolID
        The ID of the resource pool this user belongs to.
    .PARAMETER TZID
        The ID of the time zone the user is in.
    .PARAMETER AuthenticationUserName
        The authentication username of the new user. This username is what will be used when authenticating rather than the standard username field. This field only applies to non-TeamDynamix authentication types. This value should be unique across all username and authentication usernames in your organization. If the provided value is not unique, it will be ignored.
    .PARAMETER AuthenticationProviderID
        The authentication provider this user will use to authenticate by its ID. Leave this value blank to specify TeamDynamix or when using SSO authentication. This value can be obtained from the Admin application Authentication section by one of your organization's administrators who has access to modify authentication settings. If an invalid value is provided, this will use the default authentication provider for the organization.
    .PARAMETER Attributes
        The custom person attributes.
    .PARAMETER Gender
        The person's gender.
    .PARAMETER IMProvider
        The instand messenger provider for the person.
    .PARAMETER IMHandle
        The instant messenger username (or "handle") for the person.
    .EXAMPLE
        Set-TdpscPerson -UID '8fc51398-b301-e611-80ce-000d3a133f86' -AlertEmail 'MyUser0001@example.com' -PrimaryEmail 'MyUser0001@example.com' -AuthenticationUserName 'MyUser0001@example.com' -FirstName 'JohnMyUser0001' -LastName 'DoeMyUser0001'

        Updates a person with the provided parameters.
    .EXAMPLE
        Get-TdpscPerson -UID '8fc51398-b301-e611-80ce-000d3a133f86' | Set-TdpscPerson -FirstName 'John' -LastName 'Doe'

        Retrieves a specific person, passes information by pipeline. Updates a person, using the pipeline information as a base.
    .INPUTS
        String
        You can pipe a String that contains a bearer token.

        PSObject or TeamDynamix.Api.Users.User
        You can pipe a PSObject or TeamDynamix.Api.Users.User object that contains a set of new values. The object you are piping must contain all the attributes and values you want to update/retain. If a value is empty or null, it will clear the value on the person object.
    .OUTPUTS
        None or PSObject or TeamDynamix.Api.Users.User
        Set-TdpscPerson returns a PSObject or TeamDynamix.Api.Users.User object that contains the updated person. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/People#POSTapi/people/{uid}
    #>

    [CmdletBinding(DefaultParameterSetName='ByPersonParameterWithBearer', SupportsShouldProcess=$true)]
    [OutputType([PSObject], [TeamDynamix.Api.Users.User])]
    Param
    (
        [Parameter(Mandatory=$true, ParameterSetName='ByPersonParameterWithBearer', Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
		[Parameter(ParameterSetName='ByPersonParameter')]
        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$Bearer,

        [Parameter(ParameterSetName='ByPersonParameter', Position=0)]
        [Parameter(ParameterSetName='ByPersonParameterWithBearer', Position=1)]
        [PSObject]$Person,

        [Parameter(Mandatory=$true, ParameterSetName='ByIndividualParameter', ValueFromPipelineByPropertyName=$true)]
        [Guid]$UID,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [Boolean]$IsActive,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$FirstName,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$LastName,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$MiddleName,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [DateTime]$Birthday,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$Salutation,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$Nickname,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [Int32]$DefaultAccountID,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$PrimaryEmail,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$AlternateEmail,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$ExternalID,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$AlternateID,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String[]]$Applications,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$SecurityRoleID,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$AlertEmail,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$Company,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$Title,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$HomePhone,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$PrimaryPhone,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$WorkPhone,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$Pager,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$OtherPhone,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$MobilePhone,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$Fax,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [Int32]$DefaultPriorityID,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$AboutMe,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$WorkAddress,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$WorkCity,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$WorkState,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$WorkZip,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$WorkCountry,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$HomeAddress,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$HomeCity,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$HomeState,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$HomeZip,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$HomeCountry,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [Double]$DefaultRate,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [Double]$CostRate,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [Boolean]$IsEmployee,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [Double]$WorkableHours,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [Boolean]$IsCapacityManaged,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [DateTime]$ReportTimeAfterDate,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [DateTime]$EndDate,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [Boolean]$ShouldReportTime,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$ReportsToUID,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [Int32]$ResourcePoolID,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [Int32]$TZID,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$AuthenticationUserName,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [System.Nullable[Int32]]$AuthenticationProviderID,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [TeamDynamix.Api.CustomAttributes.CustomAttribute[]]$Attributes,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [TeamDynamix.Api.Users.UserGender]$Gender,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$IMProvider,

        [Parameter(ParameterSetName='ByIndividualParameter')]
        [String]$IMHandle
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

        if ($PSCmdlet.ShouldProcess('Update Account'))
        {
            if ([String]::IsNullOrWhiteSpace($Bearer)) { $Bearer = Get-InternalBearer }

            $requestBody = $null

            if ($PSBoundParameters.ContainsKey('Person'))
            {
                Write-Debug -Message 'Use existing account information from parameter (matching behavior from 1.0.0.5 and earlier)'

                $requestBody = $Person | ConvertTo-Json -Compress

                $UID = $Person.UID
            }
            else
            {
                if ($null -ne $_ -and ($_.GetType().FullName -eq 'TeamDynamix.Api.Users.User' -or $_.GetType().FullName -eq 'System.Management.Automation.PSCustomObject'))
                {
                    Write-Debug -Message 'Use existing account information from pipeline'
                    $parms = @{
                        'String' = ConvertTo-JsonSerializeObject -InputObject $_
                        'Type'   = [TeamDynamix.Api.Users.User]
                    }

                    $personModify = ConvertTo-JsonDeserializeObject @parms
                }
                else
                {
                    Write-Debug -Message 'Search for UID'
                    $personModify = Get-TdpscPerson -UID $UID
                }

                if ($null -ne $personModify)
                {
                    $personModify.IsActive                 = ($personModify.IsActive, $IsActive)[$PSBoundParameters.ContainsKey('IsActive')]
                    $personModify.FirstName                = ($personModify.FirstName, $FirstName)[$PSBoundParameters.ContainsKey('FirstName')]
                    $personModify.LastName                 = ($personModify.LastName, $LastName)[$PSBoundParameters.ContainsKey('LastName')]
                    $personModify.MiddleName               = ($personModify.MiddleName, $MiddleName)[$PSBoundParameters.ContainsKey('MiddleName')]
                    $personModify.Birthday                 = ($personModify.Birthday, $Birthday)[$PSBoundParameters.ContainsKey('Birthday')]
                    $personModify.Salutation               = ($personModify.Salutation, $Salutation)[$PSBoundParameters.ContainsKey('Salutation')]
                    $personModify.Nickname                 = ($personModify.Nickname, $Nickname)[$PSBoundParameters.ContainsKey('Nickname')]
                    $personModify.DefaultAccountID         = ($personModify.DefaultAccountID, $DefaultAccountID)[$PSBoundParameters.ContainsKey('DefaultAccountID')]
                    $personModify.PrimaryEmail             = ($personModify.PrimaryEmail, $PrimaryEmail)[$PSBoundParameters.ContainsKey('PrimaryEmail')]
                    $personModify.AlternateEmail           = ($personModify.AlternateEmail, $AlternateEmail)[$PSBoundParameters.ContainsKey('AlternateEmail')]
                    $personModify.ExternalID               = ($personModify.ExternalID, $ExternalID)[$PSBoundParameters.ContainsKey('ExternalID')]
                    $personModify.AlternateID              = ($personModify.AlternateID, $AlternateID)[$PSBoundParameters.ContainsKey('AlternateID')]
                    $personModify.Applications             = ($personModify.Applications, $Applications)[$PSBoundParameters.ContainsKey('Applications')]
                    $personModify.SecurityRoleID           = ($personModify.SecurityRoleID, $SecurityRoleID)[$PSBoundParameters.ContainsKey('SecurityRoleID')]
                    $personModify.AlertEmail               = ($personModify.AlertEmail, $AlertEmail)[$PSBoundParameters.ContainsKey('AlertEmail')]
                    $personModify.Company                  = ($personModify.Company, $Company)[$PSBoundParameters.ContainsKey('Company')]
                    $personModify.Title                    = ($personModify.Title, $Title)[$PSBoundParameters.ContainsKey('Title')]
                    $personModify.HomePhone                = ($personModify.HomePhone, $HomePhone)[$PSBoundParameters.ContainsKey('HomePhone')]
                    $personModify.PrimaryPhone             = ($personModify.PrimaryPhone, $PrimaryPhone)[$PSBoundParameters.ContainsKey('PrimaryPhone')]
                    $personModify.WorkPhone                = ($personModify.WorkPhone, $WorkPhone)[$PSBoundParameters.ContainsKey('WorkPhone')]
                    $personModify.Pager                    = ($personModify.Pager, $Pager)[$PSBoundParameters.ContainsKey('Pager')]
                    $personModify.OtherPhone               = ($personModify.OtherPhone, $OtherPhone)[$PSBoundParameters.ContainsKey('OtherPhone')]
                    $personModify.MobilePhone              = ($personModify.MobilePhone, $MobilePhone)[$PSBoundParameters.ContainsKey('MobilePhone')]
                    $personModify.Fax                      = ($personModify.Fax, $Fax)[$PSBoundParameters.ContainsKey('Fax')]
                    $personModify.DefaultPriorityID        = ($personModify.DefaultPriorityID, $DefaultPriorityID)[$PSBoundParameters.ContainsKey('DefaultPriorityID')]
                    $personModify.AboutMe                  = ($personModify.AboutMe, $AboutMe)[$PSBoundParameters.ContainsKey('AboutMe')]
                    $personModify.WorkAddress              = ($personModify.WorkAddress, $WorkAddress)[$PSBoundParameters.ContainsKey('WorkAddress')]
                    $personModify.WorkCity                 = ($personModify.WorkCity, $WorkCity)[$PSBoundParameters.ContainsKey('WorkCity')]
                    $personModify.WorkState                = ($personModify.WorkState, $WorkState)[$PSBoundParameters.ContainsKey('WorkState')]
                    $personModify.WorkZip                  = ($personModify.WorkZip, $WorkZip)[$PSBoundParameters.ContainsKey('WorkZip')]
                    $personModify.WorkCountry              = ($personModify.WorkCountry, $WorkCountry)[$PSBoundParameters.ContainsKey('WorkCountry')]
                    $personModify.HomeAddress              = ($personModify.HomeAddress, $HomeAddress)[$PSBoundParameters.ContainsKey('HomeAddress')]
                    $personModify.HomeCity                 = ($personModify.HomeCity, $HomeCity)[$PSBoundParameters.ContainsKey('HomeCity')]
                    $personModify.HomeState                = ($personModify.HomeState, $HomeState)[$PSBoundParameters.ContainsKey('HomeState')]
                    $personModify.HomeZip                  = ($personModify.HomeZip, $HomeZip)[$PSBoundParameters.ContainsKey('HomeZip')]
                    $personModify.HomeCountry              = ($personModify.HomeCountry, $HomeCountry)[$PSBoundParameters.ContainsKey('HomeCountry')]
                    $personModify.DefaultRate              = ($personModify.DefaultRate, $DefaultRate)[$PSBoundParameters.ContainsKey('DefaultRate')]
                    $personModify.CostRate                 = ($personModify.CostRate, $CostRate)[$PSBoundParameters.ContainsKey('CostRate')]
                    $personModify.IsEmployee               = ($personModify.IsEmployee, $IsEmployee)[$PSBoundParameters.ContainsKey('IsEmployee')]
                    $personModify.WorkableHours            = ($personModify.WorkableHours, $WorkableHours)[$PSBoundParameters.ContainsKey('WorkableHours')]
                    $personModify.IsCapacityManaged        = ($personModify.IsCapacityManaged, $IsCapacityManaged)[$PSBoundParameters.ContainsKey('IsCapacityManaged')]
                    $personModify.ReportTimeAfterDate      = ($personModify.ReportTimeAfterDate, $ReportTimeAfterDate)[$PSBoundParameters.ContainsKey('ReportTimeAfterDate')]
                    $personModify.EndDate                  = ($personModify.EndDate, $EndDate)[$PSBoundParameters.ContainsKey('EndDate')]
                    $personModify.ShouldReportTime         = ($personModify.ShouldReportTime, $ShouldReportTime)[$PSBoundParameters.ContainsKey('ShouldReportTime')]
                    $personModify.ReportsToUID             = ($personModify.ReportsToUID, $ReportsToUID)[$PSBoundParameters.ContainsKey('ReportsToUID')]
                    $personModify.ResourcePoolID           = ($personModify.ResourcePoolID, $ResourcePoolID)[$PSBoundParameters.ContainsKey('ResourcePoolID')]
                    $personModify.TZID                     = ($personModify.TZID, $TZID)[$PSBoundParameters.ContainsKey('TZID')]
                    $personModify.AuthenticationUserName   = ($personModify.AuthenticationUserName, $AuthenticationUserName)[$PSBoundParameters.ContainsKey('AuthenticationUserName')]
                    $personModify.AuthenticationProviderID = ($personModify.AuthenticationProviderID, $AuthenticationProviderID)[$PSBoundParameters.ContainsKey('AuthenticationProviderID')]
                    $personModify.Attributes               = ($personModify.Attributes, $Attributes)[$PSBoundParameters.ContainsKey('Attributes')]
                    $personModify.Gender                   = ($personModify.Gender, $Gender)[$PSBoundParameters.ContainsKey('Gender')]
                    $personModify.IMProvider               = ($personModify.IMProvider, $IMProvider)[$PSBoundParameters.ContainsKey('IMProvider')]
                    $personModify.IMHandle                 = ($personModify.IMHandle, $IMHandle)[$PSBoundParameters.ContainsKey('IMHandle')]

                    $requestBody = ConvertTo-JsonSerializeObject -InputObject $personModify
                }
                else
                {
                    Write-Error -Message "Person ID $($UID) returned no information. Person may no longer be active and accessible through Web API."
                }
            }

            if ($null -ne $requestBody)
            {
                $parms = @{
                    Body            = $requestBody
                    ContentType     = 'application/json'
                    Headers         = @{
                                            Authorization = 'Bearer ' + $Bearer
                                        }
                    Method          = 'Post'
                    Uri             = (Get-TdpscApiBaseAddress) + "people/$($UID)"
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
    }
    End
    {
        Write-Debug -Message "[$($MyInvocation.MyCommand.Name)] complete"
    }
}

function Set-TdpscPersonFunctionalRole
{
    <#
    .SYNOPSIS
        Adds the user to functional role.
    .DESCRIPTION
        Use Set-TdpscPersonFunctionalRole to add the user to the functional role if they are not already in that role. If they are in that role, this will update whether or not that role is the user's primary functional role.

        This action can only be performed by administrative accounts and not standard TeamDynamix users.

        Invocations of this method are rate-limited, with a restriction of 180 calls per IP every 60 seconds.
    .PARAMETER Bearer
        Bearer token received when logging in.
    .PARAMETER UID
        The user unique identifier.
    .PARAMETER RoleID
        The functional role ID.
    .PARAMETER IsPrimary
        Indicates whether or not to set this role as the user's primary functional role.
    .EXAMPLE
        Set-TdpscPersonFunctionalRole -UID '313f362a-b885-4ea9-996a-6cc9c9eb039b' -RoleID 6586 -IsPrimary $true

        Adds the role ID, set this role as the user's primary functional role.
    .EXAMPLE
        Get-TdpscPerson -UID '313f362a-b885-4ea9-996a-6cc9c9eb039b' | Set-TdpscPersonFunctionalRole -RoleID 6586

        Get UID by pipeline, adds the role ID, set as non-primary functional role.
    .INPUTS
        PSObject or TeamDynamix.Api.Users.User
        You can pipe a PSObject or TeamDynamix.Api.Users.User object that contains the user's UID.
    .OUTPUTS
        None or String
        Set-TdpscPersonFunctionalRole returns a response message indicating if the operation was successful (OK) or not. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/People#PUTapi/people/{uid}/functionalroles/{roleId}?isPrimary={isPrimary}
    #>

    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([TeamDynamix.Api.Roles.UserFunctionalRole], [System.Object[]])]
    Param
    (
        [String]$Bearer,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Guid]$UID,

        [Parameter(Mandatory=$true)]
		[Int32]$RoleID,

        [Parameter()]
		[Boolean]$IsPrimary = $false
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

        if ($PSCmdlet.ShouldProcess("User ID: $($UID), Role ID: $($RoleID)", 'Add User To Role'))
        {
            if ([String]::IsNullOrWhiteSpace($Bearer)) { $Bearer = Get-InternalBearer }

            $parms = @{
                ContentType     = 'application/json'
                Headers         = @{
                                        Authorization = 'Bearer ' + $Bearer
                                    }
                Method          = 'Put'
                Uri             = (Get-TdpscApiBaseAddress) + "people/$($UID)/functionalroles/$($RoleID)?isPrimary=$($IsPrimary)"
                UseBasicParsing = $true
            }

            Write-Debug -Message ($parms | Out-String)

            $request = Invoke-WebRequest @parms

            $request.StatusDescription
        }
    }
    End
    {
        Write-Debug -Message "[$($MyInvocation.MyCommand.Name)] complete"
    }
}

function Set-TdpscPersonGroup
{
    <#
    .SYNOPSIS
        Adds the user to group.
    .DESCRIPTION
        Use Set-TdpscPersonGroup to add the user to the group if they are not already in that group. If they are in that group, this will update whether or not that group is the user's primary group, whether they are notified along with the group, and if they are the manager of the group.

        This action can only be performed by administrative accounts and not standard TeamDynamix users.

        Invocations of this method are rate-limited, with a restriction of 180 calls per IP every 60 seconds.
    .PARAMETER Bearer
        Bearer token received when logging in.
    .PARAMETER UID
        The user unique identifier.
    .PARAMETER GroupID
        The ID of the group to add. Must match up with a pre-existing group.
    .PARAMETER IsPrimary
        Whether or not this is the user's primary group. If set to true, this will clear out any existing primary group.
    .PARAMETER IsNotified
        Whether or not this user is notified along with this group.
    .PARAMETER IsManager
        Whether or not this user is a group manager.
    .EXAMPLE
        Set-TdpscPersonGroup -UID '313f362a-b885-4ea9-996a-6cc9c9eb039b' -GroupID 3863 -IsPrimary $true

        Adds the group ID, set this role as the user's primary group.
    .EXAMPLE
        Get-TdpscPerson -UID '313f362a-b885-4ea9-996a-6cc9c9eb039b' | Set-TdpscPersonGroup -GroupID 3862

        Get UID by pipeline, adds the group ID, set as non-primary group.
    .INPUTS
        PSObject or TeamDynamix.Api.Users.User
        You can pipe a PSObject or TeamDynamix.Api.Users.User object that contains the user's UID.
    .OUTPUTS
        None or String
        Set-TdpscPersonGroup returns a response message indicating if the operation was successful (OK) or not. Otherwise, this cmdlet does not generate any output.
    .LINK
        Web API details
        https://app.teamdynamix.com/TDWebApi/Home/section/People#PUTapi/people/{uid}/groups/{groupID}?isPrimary={isPrimary}&isNotified={isNotified}&isManager={isManager}
    #>

    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([TeamDynamix.Api.Roles.UserFunctionalRole], [System.Object[]])]
    Param
    (
        [String]$Bearer,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Guid]$UID,

        [Parameter(Mandatory=$true)]
		[Int32]$GroupID,

        [Parameter()]
		[Boolean]$IsPrimary = $false,

        [Parameter()]
		[Boolean]$IsNotified = $false,

        [Parameter()]
		[Boolean]$IsManager = $false
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

        if ($PSCmdlet.ShouldProcess("User ID: $($UID), Group ID: $($GroupID)", 'Add User To Group'))
        {
            if ([String]::IsNullOrWhiteSpace($Bearer)) { $Bearer = Get-InternalBearer }

            $parms = @{
                ContentType     = 'application/json'
                Headers         = @{
                                        Authorization = 'Bearer ' + $Bearer
                                    }
                Method          = 'Put'
                Uri             = (Get-TdpscApiBaseAddress) + "people/$($UID)/groups/$($GroupID)?isPrimary=$($IsPrimary)&isNotified=$($IsNotified)&isManager=$($IsManager)"
                UseBasicParsing = $true
            }

            Write-Debug -Message ($parms | Out-String)

            $request = Invoke-WebRequest @parms

            $request.StatusDescription
        }
    }
    End
    {
        Write-Debug -Message "[$($MyInvocation.MyCommand.Name)] complete"
    }
}

Export-ModuleMember -Function Get-TdpscPerson
Export-ModuleMember -Function Get-TdpscPersonFunctionalRole
Export-ModuleMember -Function Get-TdpscPersonGroup
Export-ModuleMember -Function Get-TdpscPersonSearch
Export-ModuleMember -Function Get-TdpscRestrictedPersonSearch
Export-ModuleMember -Function New-TdpscPerson
Export-ModuleMember -Function New-TdpscPersonImport
Export-ModuleMember -Function Remove-TdpscPersonFunctionalRole
Export-ModuleMember -Function Remove-TdpscPersonGroup
Export-ModuleMember -Function Set-TdpscPerson
Export-ModuleMember -Function Set-TdpscPersonFunctionalRole
Export-ModuleMember -Function Set-TdpscPersonGroup
