#Requires -Version 3

Set-StrictMode -Version 3

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
