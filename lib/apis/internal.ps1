#Requires -Version 3

Set-StrictMode -Version 3

function Get-UploadBoundaryEncodedByte
{
    <#
    .Synopsis
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
        # Reads the contents of V:\my-sample-file.xlsx and stores the data into the $uploadFileData variable.

        $param = @{
            Path                        = 'V:\my-sample-file.xlsx'
            EncodingName                = 'iso-8859-1'
            Boundary                    = [System.Guid]::NewGuid().ToString()
            ContentDispositionFieldName = 'UploadFileData'
            ContentDispositionFileName  = 'MyUploadedFile.xlsx'
            ContentType                 = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        }
        $uploadFileData = Get-UploadBoundaryEncodedByte @param
    .INPUTS
        None.
    .OUTPUTS
        None.
    .LINK
        Created function for multi-part upload:
        http://stackoverflow.com/questions/25075010/upload-multiple-files-from-powershell-script/34771519
    #>

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
