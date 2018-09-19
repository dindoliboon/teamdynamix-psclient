#Requires -Version 3

Set-StrictMode -Version 3

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
