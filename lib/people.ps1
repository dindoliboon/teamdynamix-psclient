<#
.Synopsis
    Performs a restricted lookup of TeamDynamix people. Will not return full user information for each matching user.
.DESCRIPTION
    Invocations of this method are rate-limited, with a restriction of 10 calls per IP every 1 second.
.PARAMETER Bearer
    Bearer token received when logging in.
.PARAMETER SearchText
    The searching text to use.
.PARAMETER MaxResults
    The maximum number of results to return. Must be in the range 1-100, and will default to 50.
.EXAMPLE
    Pass the bearer token by parameter.

    $Users = Get-TdpscRestrictedPersonSearch -Bearer $Bearer -SearchText 'John Doe'
.INPUTS
    System.String

    You can pipe a bearer token (string) to Get-TdpscRestrictedPersonSearch.
.OUTPUTS
    PSObject. A filtered set of TeamDynamix people. (IEnumerable(Of TeamDynamix.Api.Users.User))
.LINK
    https://app.teamdynamix.com/TDWebApi/Home/section/People#GETapi/people/lookup?searchText={searchText}&maxResults={maxResults}
#>
function Get-TdpscRestrictedPersonSearch
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
		[String]$Bearer,

		[String]$SearchText,

		[Int32]$MaxResults = 50
    )

    Begin
    {
        $url    = "https://app.teamdynamix.com/TDWebApi/api/people/lookup?maxResults=$MaxResults&searchText=$([System.Uri]::EscapeDataString($SearchText))"
        $result = $null
    }
    Process
    {
        if ($PSCmdlet.ShouldProcess($Bearer, 'Performs a restricted lookup of TeamDynamix people.'))
        {
            $resp    = Invoke-WebRequest -Uri $url -ContentType 'application/json' -Method Get -Headers @{'Authorization' = 'Bearer ' + $Bearer} -UseBasicParsing
            $result  = $resp.Content | ConvertFrom-Json
        }
    }
    End
    {
        $result
    }
}

<#
.Synopsis
   Gets a list of users. Does not return collection objects such as Applications, Permissions, Groups, or Custom Attributes. Use the singular GET to retrieve these collections for a singular user.
.DESCRIPTION
   This action requires access to the TDPeople application.

   Invocations of this method are rate-limited, with a restriction of 60 calls per IP every 60 seconds.

   If you are attempting to look up basic user information using a simple search string, consider using the GET api/people/lookup method instead.
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
   Pass the bearer token by parameter.

   $Users = Get-TdpscPersonSearch -Bearer $Bearer -SearchText 'John Doe'
.INPUTS
   System.String

   You can pipe a bearer token (string) to Get-TdpscPersonSearch.
.OUTPUTS
   PSObject. A collection of users. (IEnumerable(Of TeamDynamix.Api.Users.User))
.LINK
   https://app.teamdynamix.com/TDWebApi/Home/section/People#POSTapi/people/search
#>
function Get-TdpscPersonSearch
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
        $url    = 'https://app.teamdynamix.com/TDWebApi/api/people/search'
        $result = $null
    }
    Process
    {
        if ($PSCmdlet.ShouldProcess($Bearer, 'Gets a list of users.'))
        {
            $request        = @{
                'SearchText' = $SearchText
                'IsActive'   = $IsActive
                'IsEmployee' = $IsEmployee
                'AppName'    = $AppName
                'AccountID'  = $AccountID
                'MaxResults' = $MaxResults
            } | ConvertTo-Json -Compress
            Write-Debug -Message "JSON request: $request"
            $resp    = Invoke-WebRequest -Uri $url -Body $request -ContentType 'application/json' -Method Post -Headers @{'Authorization' = 'Bearer ' + $Bearer} -UseBasicParsing
            $result  = $resp.Content | ConvertFrom-Json
        }
    }
    End
    {
        $result
    }
}

<#
.Synopsis
   Accepts a file, stores that file on disk, and places an entry into the database to indicate to the import file processor to pick up the file and run a People Import on it.
.DESCRIPTION
   This action accepts an uploaded file as part of the form's submission. For information on how to structure calls with files, see the Submitting Files page.

   This action can only be performed by administrative accounts and not standard TeamDynamix users.
.PARAMETER Bearer
   Bearer token received when logging in.
.PARAMETER Path
   Location to the XLSX file.
.EXAMPLE
   Pass the bearer token by parameter.

   $Result = New-TdpscPersonImport -Bearer $Bearer -Path 'V:\MyTdFile.xlsx'
.INPUTS
   System.String

   You can pipe a bearer token (string) to New-TdpscPersonImport.
.OUTPUTS
   PSObject. A collection of users. (IEnumerable(Of TeamDynamix.Api.Users.User))
.LINK
   https://app.teamdynamix.com/TDWebApi/Home/section/People#POSTapi/people/import
.LINK
   https://app.teamdynamix.com/TDWebApi/Home/AboutFileSubmission
.LINK
   https://solutions.teamdynamix.com/TDClient/KB/ArticleDet?ID=4191
#>
function New-TdpscPersonImport
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
		[String]$Bearer,

		[String]$Path
    )

    Begin
    {
        $url    = 'https://app.teamdynamix.com/TDWebApi/api/people/import'
        $result = $null
    }
    Process
    {
        if ($PSCmdlet.ShouldProcess($Bearer, 'Gets a list of users.'))
        {
            # http://stackoverflow.com/users/14455/akauppi
            # http://stackoverflow.com/questions/25075010/upload-multiple-files-from-powershell-script/34771519
            $fileBin = [System.IO.File]::ReadAllBytes($Path)
            $enc = [System.Text.Encoding]::GetEncoding('iso-8859-1')
            $fileEnc = $enc.GetString($fileBin)
            $boundary = [System.Guid]::NewGuid().ToString()

$request = @"
--$boundary
Content-Disposition: form-data; name="fieldNameHere"; filename="PeopleImportTemplate.xlsx"
Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet

$fileEnc
--$boundary--
"@
            $result = Invoke-WebRequest -Uri $url -Body $request -ContentType "multipart/form-data; boundary=`"$boundary`"" -Method Post -Headers @{'Authorization' = 'Bearer ' + $Bearer;} -UseBasicParsing
            $result = $result.StatusDescription
        }
    }
    End
    {
        $result
    }
}

<#
.Synopsis
   Gets a person from the system.
.PARAMETER Bearer
   Bearer token received when logging in.
.PARAMETER UID
   The user unique identifier.
.EXAMPLE
   $Person = Get-TdpscPerson -Bearer $Bearer -UID 'ec57223c-980c-4d17-8133-d9553f49b519'
.INPUTS
   System.String

   You can pipe a bearer token (string) to Get-TdpscPerson.
.OUTPUTS
   The person if it was found. (TeamDynamix.Api.Users.User)
.LINK
   https://app.teamdynamix.com/TDWebApi/Home/section/People#GETapi/people/{uid}
#>
function Get-TdpscPerson
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
		[String]$Bearer,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
		[String]$UID
    )

    Begin
    {
        $url    = "https://app.teamdynamix.com/TDWebApi/api/people/$($UID)"
        $result = $null
    }
    Process
    {
        if ($PSCmdlet.ShouldProcess($Bearer, 'Gets a person from the system.'))
        {
            $resp    = Invoke-WebRequest -Uri $url -ContentType 'application/json' -Method Get -Headers @{'Authorization'='Bearer ' + $Bearer} -UseBasicParsing
            $result = $resp.Content | ConvertFrom-Json
        }
    }
    End
    {
        $result
    }
}

<#
.Synopsis
   Updates a person entry for the user with the specified identifier with a set of new values.
.DESCRIPTION
   Invocations of this method are rate-limited, with a restriction of 45 calls per IP every 60 seconds.
.PARAMETER Bearer
   Bearer token received when logging in.
.PARAMETER Person
   New values.
.EXAMPLE
    # Department is set based off account ID.
    $NewPersonValue.DefaultAccountID = 33616
    $NewPersonValue.WorkCity = ''
   $UpdatedPersonResult = Set-TdpscPerson -Bearer $Bearer -Person $NewPersonValue
.INPUTS
   System.String

   You can pipe a bearer token (string) to Set-TdpscPerson.
.OUTPUTS
   The modified user object. (TeamDynamix.Api.Users.User)
.LINK
   https://app.teamdynamix.com/TDWebApi/Home/section/People#POSTapi/people/{uid}
#>
function Set-TdpscPerson
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
		[String]$Bearer,

		[PSObject]$Person
    )

    Begin
    {
        $url    = "https://app.teamdynamix.com/TDWebApi/api/people/$($Person.UID)"
        $result = $null
    }
    Process
    {
        if ($PSCmdlet.ShouldProcess($Bearer, 'Updates a person with a new set of values.'))
        {
            $request = $Person | ConvertTo-Json -Compress
            $resp    = Invoke-WebRequest -Uri $url -Body $request -ContentType 'application/json' -Method Post -Headers @{'Authorization'='Bearer ' + $Bearer} -UseBasicParsing
            $result = $resp.Content | ConvertFrom-Json
        }
    }
    End
    {
        $result
    }
}

Export-ModuleMember -Function Get-TdpscRestrictedPersonSearch
Export-ModuleMember -Function Get-TdpscPersonSearch
Export-ModuleMember -Function New-TdpscPersonImport
Export-ModuleMember -Function Get-TdpscPerson
Export-ModuleMember -Function Set-TdpscPerson
