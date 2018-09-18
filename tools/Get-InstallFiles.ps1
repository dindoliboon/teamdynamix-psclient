<#
    Creates a list of subfolders and files for Install.ps1 based on a specific path.

    Outputs information similar to the list below.
        $fileList = @(
            'lib\',
            'samples\',
            '_secret\',
            'Install.ps1',
            'teamdynamix-psclient.psd1',
            'teamdynamix-psclient.psm1',
            'lib\accounts.ps1',
            'lib\auth.ps1',
            'lib\people.ps1',
            'samples\Sample-Get-Department.ps1',
            'samples\Sample-Get-PersonSearch.ps1',
            'samples\Sample-New-AdminSession.ps1',
            'samples\Sample-New-ExcelImportTemplate.ps1',
            'samples\Sample-New-PersonImport.ps1',
            'samples\Sample-Set-Person.ps1',
            'samples\Sample-Set-PersonDisabled.ps1'
        )

    Get-InstallFiles.ps1 -Path 'V:\Documents\Projects\TeamDynamix\teamdynamix-psclient\1.0.0.4' | Clip
#>

Param(
	[Parameter(Mandatory=$true)]
    [String]$Path
)

#Requires -Version 3

Set-StrictMode -Version 3

$Script:DebugPreference       = 'SilentlyContinue'
$Script:VerbosePreference     = 'SilentlyContinue'

$PathWithSlash = Resolve-Path -Path ($Path + '\')

Write-Debug -Message "Get list of all files under sub folder [$PathWithSlash]"
$fileList = @()
Get-ChildItem -Path $PathWithSlash -Recurse | ForEach-Object {
    Write-Debug -Message "Remove root path [$PathWithSlash] from fullname [$($_.FullName)], add trailing backslash if directory [$($_.PSIsContainer)]"
    $fileList += $_.FullName.Replace($PathWithSlash, '') + ('{0}' -f ('', '\')[$_.PSIsContainer])
}

Write-Debug -Message 'Create array containing directory listing'
"`$fileList = @("
$fileList  | ForEach-Object {
    "    '$_'{0}" -f (',', '')[$fileList[-1] -like $_]
}
')'
