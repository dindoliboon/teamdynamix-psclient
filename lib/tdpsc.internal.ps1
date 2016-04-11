#Requires -Version 3

Set-StrictMode -Version 3

function Get-UploadBoundaryEncodedByte
{
    <#
    .SYNOPSIS
        Encapsulates file data within a specified boundary for a multipart file upload.
    .DESCRIPTION
        Encapsulates file data within a specified boundary for a multipart file upload.
    .PARAMETER Path
        The file to open for uploading.
    .PARAMETER EncodingName
        The code page name of the preferred encoding. Any value returned by the WebName property is valid. Possible values are listed in the Name column of the table that appears in the Encoding class topic.
    .PARAMETER Boundary
        Unique name of the boundary.
    .PARAMETER ContentDispositionFieldName
        Original field name in form.
    .PARAMETER ContentDispositionFileName
        Name to be used when uploading the file.
    .PARAMETER ContentType
        Specifies the HTTP content type for the request.
    .EXAMPLE
        $param = @{
            Path                        = 'V:\my-sample-file.xlsx'
            EncodingName                = 'iso-8859-1'
            Boundary                    = [System.Guid]::NewGuid().ToString()
            ContentDispositionFieldName = 'UploadFileData'
            ContentDispositionFileName  = 'MyUploadedFile.xlsx'
            ContentType                 = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        }
        $uploadFileData = Get-UploadBoundaryEncodedByte @param
 
        Reads the contents of V:\my-sample-file.xlsx and stores the data into the $uploadFileData variable.
    .INPUTS
        None
        You cannot pipe objects to this cmdlet.
    .OUTPUTS
        String
        Returns a string object that contains the file data encapsulated within the specified boundary.
   .LINK
        Created function for multi-part upload
        http://stackoverflow.com/questions/25075010/upload-multiple-files-from-powershell-script/34771519
    #>

    [CmdletBinding()]
    [OutputType([String])]
    Param
    (
        $Path,
        $EncodingName,
        $Boundary,
        $ContentDispositionFieldName,
        $ContentDispositionFileName,
        $ContentType
    )

    $fileBin = [System.IO.File]::ReadAllBytes($Path)
    $enc = [System.Text.Encoding]::GetEncoding($EncodingName)
    $fileEnc = $enc.GetString($fileBin)

    @"
--$($Boundary)
Content-Disposition: form-data; name="$($ContentDispositionFieldName)"; filename="$($ContentDispositionFileName)"
Content-Type: $($ContentType)

$($fileEnc)
--$($Boundary)--
"@

}

function Set-TdpscApiBaseAddress
{
    <#
    .SYNOPSIS
        Configures using the production or sandbox Web API.
    .DESCRIPTION
        Configures using the production or sandbox Web API.
    .PARAMETER Uri
        A custom web URI that hosts your TeamDynamix Web API.
    .PARAMETER Target
        Specifies which API environment to use.
    .EXAMPLE
        Set-TdpscApiBaseAddress -Target 'Production'

        Sets the Web API address to the production URI.
    .EXAMPLE
        Set-TdpscApiBaseAddress -Target 'Sandbox'

        Sets the Web API address to the sandox URI.
    .EXAMPLE
        Set-TdpscApiBaseAddress

        Sets the Web API address to the sandox URI.
    .EXAMPLE
        Set-TdpscApiBaseAddress -Uri 'https://app.localhost/TestWebApi/api/'

        Sets the WEB API to a custom address.
    .INPUTS
        None
        You cannot pipe objects to this cmdlet.
    .OUTPUTS
        String
        Returns the Web API address.
    #>

    [CmdletBinding(DefaultParameterSetName='Target', SupportsShouldProcess=$true)]
    [OutputType([String])]
    Param
    (
        [Parameter(ParameterSetName='Uri')]
        [String]$Uri,

        [Parameter(ParameterSetName='Target')]
        [ValidateSet('Production', 'Sandbox')]
        [String]$Target
    )

    $newUri = $null
    $oldUri = $MyInvocation.MyCommand.Module.PrivateData['TDWebApiBaseAddress']

    if ([string]::IsNullOrEmpty($Uri) -eq $false)
    {
        $newUri = $Uri
    }
    else
    {
        if ($Target -like 'Production')
        {
            $newUri = 'https://app.teamdynamix.com/TDWebApi/api/'
        }
        else
        {
            $newUri = 'https://app.teamdynamix.com/SBTDWebApi/api/'
        }
    }

    if ($PSCmdlet.ShouldProcess("Update API URI from [$($oldUri)] to [$($newUri)].", 'Update API URI'))
    {
        if ($null -ne $newUri)
        {
            $MyInvocation.MyCommand.Module.PrivateData['TDWebApiBaseAddress'] = $newUri
        }

        $MyInvocation.MyCommand.Module.PrivateData['TDWebApiBaseAddress']
    }
}

function Get-TdpscApiBaseAddress
{
    <#
    .SYNOPSIS
        Returns the Web API address.
    .DESCRIPTION
        Returns the Web API address.
    .EXAMPLE
        Get-TdpscApiBaseAddress

        Gets the Web API address.
    .INPUTS
        None
        You cannot pipe objects to this cmdlet.
    .OUTPUTS
        String
        Returns the Web API address.
    #>

    [CmdletBinding()]
    [OutputType([String])]
    Param
    (
    )

    $MyInvocation.MyCommand.Module.PrivateData['TDWebApiBaseAddress']
}

function Get-InternalBearer
{
    <#
    .SYNOPSIS
        Returns the internal bearer token.
    .DESCRIPTION
        Returns the internal bearer token.
    .EXAMPLE
        Get-InternalBearer

        Gets the internal bearer token.
    .INPUTS
        None
        You cannot pipe objects to this cmdlet.
    .OUTPUTS
        String
        Returns the internal bearer token.
    #>

    [CmdletBinding()]
    [OutputType([String])]
    Param
    (
    )

    if ([String]::IsNullOrWhiteSpace($MyInvocation.MyCommand.Module.PrivateData['TDWebApiBearer']))
    {
        Write-Error -Message 'No bearer token provided. Renew your bearer token with New-TdpscAuth, New-TdpscAuthCached, New-TdpscAuthLogin, or New-TdpscAuthLoginAdmin.'
    }
    else
    {
        $MyInvocation.MyCommand.Module.PrivateData['TDWebApiBearer']
    }
}

function Set-InternalBearer
{
    <#
    .SYNOPSIS
        Sets the internal bearer to a specified string.
    .DESCRIPTION
        Sets the internal bearer to a specified string.
    .PARAMETER Bearer
        Bearer token received when logging in.
    .PARAMETER PassThru
        Returns a String object that represents the bearer token. By default, this cmdlet returns a Boolean value indicating success/failure of updating the bearer token.
    .PARAMETER Clear
        Remove the internal bearer token.
    .EXAMPLE
        Set-InternalBearer -Bearer 'new bearer token'
 
        Updates the internal bearer token, returns the value indicating success/failure.
    .EXAMPLE
        Set-InternalBearer -Bearer 'new bearer token' -PassThru
 
        Updates the internal bearer token, returns the bearer token.
    .EXAMPLE
        Set-InternalBearer -Clear
 
        Remove the internal bearer token.
    .INPUTS
        None
        You cannot pipe objects to this cmdlet.
    .OUTPUTS
        None or Boolean or String
        Returns True on success, False on failure of setting the internal bearer.

        If PassThru is enabled, it returns the value of the internal bearer token. Otherwise, this cmdlet does not generate any output.
    #>

    [CmdletBinding(DefaultParameterSetName='Bearer', SupportsShouldProcess=$true)]
    [OutputType([Boolean], [String])]
    Param
    (
        [Parameter(ParameterSetName='Bearer')]
        [String]$Bearer,

        [Parameter(ParameterSetName='Bearer')]
        [Parameter(ParameterSetName='Clear')]
        [Switch]$PassThru,

        [Parameter(ParameterSetName='Clear')]
        [Switch]$Clear

    )

    if ($PSCmdlet.ShouldProcess("Update internal bearer from [$($MyInvocation.MyCommand.Module.PrivateData['TDWebApiBearer'])] to [$($Bearer)].", 'Update internal bearer'))
    {
        $result = $false

        if ($PSBoundParameters.ContainsKey('Clear'))
        {
            Write-Debug -Message 'Set bearer to null'
            $MyInvocation.MyCommand.Module.PrivateData['TDWebApiBearer'] = $null
            $result = $true
        }
        else
        {
            try
            {
                $jwt = Decode-JWT -rawToken $Bearer
                if ($jwt.headers.typ -eq 'JWT')
                {
                    Write-Debug -Message 'Update bearer, string has JWT header type'
                    $MyInvocation.MyCommand.Module.PrivateData['TDWebApiBearer'] = $Bearer
                    $result = $true
                }
            }
            catch
            {
                Write-Warning -Message 'Unable to set internal bearer, could be an invalid/malformed token.'
            }
        }

        if ($PSBoundParameters.ContainsKey('PassThru'))
        {
            if ($result -eq $true)
            {
                $Bearer
            }
            else
            {
                # Return nothing if Bearer is invalid with PassThru
            }
        }
        else
        {
            $result
        }
    }
}

function Get-TdReturnApiType
{
    <#
    .SYNOPSIS
        Determines if a PSObject or the actual TeamDynamix object type should be returned.
    .DESCRIPTION
        Determines if a PSObject or the actual TeamDynamix object type should be returned.

        The initial version of teamdynamix-psclient returned PSObjects. Newer versions deserialize JSON objects into the correct data type.

        The default is to return PSObjects.
    .EXAMPLE
        Get-TdReturnApiType

        Determines if a PSObject or the actual TeamDynamix object type should be returned.
    .INPUTS
        None
        You cannot pipe objects to this cmdlet.
    .OUTPUTS
        Boolean
        Returns True if TeamDynamix objects will be returned, otherwise False to return PSobjects.
    #>

    [CmdletBinding()]
    [OutputType([Boolean])]
    Param
    (
    )

    if ([String]::IsNullOrWhiteSpace($MyInvocation.MyCommand.Module.PrivateData['TDReturnApiType']) -eq $false)
    {
        # New-ModuleManifest writes as String instead of Boolean
        $MyInvocation.MyCommand.Module.PrivateData['TDReturnApiType'] -eq 'True'
    }
    else
    {
        $false
    }
}

function ConvertTo-JsonDeserializeObject
{
    <#
    .SYNOPSIS
        Converts the specified JSON string to an object of type T.
    .DESCRIPTION
        Converts the specified JSON string to an object of type T.
    .PARAMETER String
        The JSON string to be deserialized.
    .PARAMETER Type
        The type of the resulting object.
    .EXAMPLE
        $account = '[{"ID":1,"Name":"Testing Division","IsActive":true,"Address1":"","Address2":"","Address3":"","Address4":"","City":"","StateName":"","StateAbbr":"  ","PostalCode":"","Country":"","Phone":"","Fax":"","Url":"","Notes":"","CreatedDate":"\/Date(1456247820000)\/","ModifiedDate":"\/Date(1456247820000)\/","Code":"","IndustryID":0,"IndustryName":"","Domain":""},{"ID":2,"Name":"Information Technology Services","IsActive":true,"Address1":"","Address2":"","Address3":"","Address4":"","City":"","StateName":"","StateAbbr":"  ","PostalCode":"","Country":"","Phone":"","Fax":"","Url":"","Notes":"","CreatedDate":"\/Date(1456247820000)\/","ModifiedDate":"\/Date(1456247820000)\/","Code":"","IndustryID":0,"IndustryName":"","Domain":""}]'
        ConvertTo-JsonDeserializeObject -String $account -Type TeamDynamix.Api.Accounts.Account
 
        Converts the JSON string into an objects of type TeamDynamix.Api.Accounts.Account.
    .INPUTS
        None
        You cannot pipe objects to this cmdlet.
    .OUTPUTS
        T
        Returns the specified deserialized object.
   .LINK
        JavaScriptSerializer.Deserialize<T> Method (String)
        https://msdn.microsoft.com/en-us/library/bb355316(v=vs.110).aspx
    #>

    [CmdletBinding()]
    [OutputType([Type])]
    Param
    (
        [String]$String,

        [Type]$Type
    )

    $serializer = New-Object -TypeName System.Web.Script.Serialization.JavaScriptSerializer
    $serializer.Deserialize($String, [Type]$Type)
}

function ConvertTo-JsonSerializeObject
{
    <#
    .SYNOPSIS
        Converts an object to a JSON-formatted string.
    .DESCRIPTION
        The ConvertTo-JsonSerializeObject cmdlet converts any object to a string in JavaScript Object Notation (JSON) format. 
    .PARAMETER InputObject
        Specifies the objects to convert to JSON format. Enter a variable that contains the objects, or type a command or expression that gets the objects.
    .EXAMPLE
        ConvertTo-JsonSerializeObject -InputObject @{Account="User01";Domain="Domain01";Admin="True"}
 
        Converts the object to a JSON-formatted string.
    .INPUTS
        None
        You cannot pipe objects to this cmdlet.
    .OUTPUTS
        System.String
        The JSON-formatted string.
   .LINK
        ConvertTo-Json
        https://technet.microsoft.com/en-us/library/hh849922.aspx
    #>

    [CmdletBinding()]
    [OutputType([String])]
    Param
    (
        [Object]$InputObject
    )

    #$serializer = New-Object -TypeName System.Web.Script.Serialization.JavaScriptSerializer
    #$serializer.Serialize($InputObject)

    ConvertTo-Json -InputObject $InputObject -Compress
}

function ConvertTo-LocalTime
{
    <#
    .SYNOPSIS
        Returns the local time that corresponds to a specified date and time value.
    .DESCRIPTION
        Returns the local time that corresponds to a specified date and time value.
    .PARAMETER Date
        A Coordinated Universal Time (UTC) time.
    .EXAMPLE
        ConvertTo-LocalTime -Date '1460062500'

        Returns Thursday, April 7, 2016 4:55:00 PM.
    .INPUTS
        None
        You cannot pipe objects to this cmdlet.
    .OUTPUTS
        DateTime
        A DateTime object whose value is the local time that corresponds to time.
   .LINK
        TimeZone.ToLocalTime Method (DateTime)
        https://msdn.microsoft.com/en-us/library/system.timezone.tolocaltime(v=vs.110).aspx
    #>

    [CmdletBinding()]
    [OutputType([DateTime])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
		[String]$Date
    )

    [TimeZone]::CurrentTimeZone.ToLocalTime(([DateTime]'1/1/1970').AddSeconds($Date))
}

Export-ModuleMember -Function Set-TdpscApiBaseAddress
Export-ModuleMember -Function Get-TdpscApiBaseAddress
