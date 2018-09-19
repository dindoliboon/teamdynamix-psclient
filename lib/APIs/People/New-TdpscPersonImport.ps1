#Requires -Version 3

Set-StrictMode -Version 3

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
