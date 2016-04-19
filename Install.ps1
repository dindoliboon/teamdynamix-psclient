<#

    Run:
    iex (New-Object System.Net.WebClient).DownloadString('https://raw.github.com/dindoliboon/teamdynamix-psclient/master/Install.ps1')
    
    Install.ps1 from:
    https://github.com/lzybkr/TabExpansionPlusPlus

#>

param([string]$Path)

$githubBase    = 'https://raw.github.com/dindoliboon'
$moduleName    = 'teamdynamix-psclient'
$moduleVersion = '1.0.0.6'

$fileList = @(
    'lib\',
    'samples\',
    'tools\',
    '_secret\',
    '.gitattributes',
    'Install.ps1',
    'LICENSE.md',
    'Readme.md',
    'teamdynamix-psclient.psd1',
    'teamdynamix-psclient.psm1',
    'lib\apis\',
    'lib\Decode-JwtToken.internal.ps1',
    'lib\tdpsc.internal.ps1',
    'lib\tdtypes.internal.ps1',
    'lib\apis\accounts.ps1',
    'lib\apis\accounts.tests.ps1',
    'lib\apis\attachments.ps1',
    'lib\apis\attachments.tests.ps1',
    'lib\apis\attributes.ps1',
    'lib\apis\attributes.tests.ps1',
    'lib\apis\auth.ps1',
    'lib\apis\auth.tests.ps1',
    'lib\apis\groups.ps1',
    'lib\apis\groups.tests.ps1',
    'lib\apis\locations.ps1',
    'lib\apis\locations.tests.ps1',
    'lib\apis\people.ps1',
    'lib\apis\people.tests.ps1',
    'samples\Sample-Get-Department.ps1',
    'samples\Sample-Get-PersonSearch.ps1',
    'samples\Sample-New-AdminSession.ps1',
    'samples\Sample-New-ExcelImportTemplate.ps1',
    'samples\Sample-New-PersonImport.ps1',
    'samples\Sample-Set-Person.ps1',
    'samples\Sample-Set-PersonDisabled.ps1',
    'tools\Export-TdWebApiTypes.ps1',
    'tools\Get-InstallFiles.ps1',
    'tools\Get-WebRequestTable.ps1',
    'tools\Invoke-PreparePublish.ps1',
    'tools\Invoke-PSScriptAnalyzer.ps1'
)

if ('' -eq $Path)
{
    $personalModules = Join-Path -Path ([Environment]::GetFolderPath('MyDocuments')) -ChildPath 'WindowsPowerShell\Modules'
    if (($env:PSModulePath -split ';') -notcontains $personalModules)
    {
        Write-Warning -Message "$personalModules is not in `$env:PSModulePath"
    }

    if (!(Test-Path -Path $personalModules))
    {
        Write-Error -Message "$personalModules does not exist"
    }

    $Path = Join-Path -Path $personalModules -ChildPath $moduleName

    Write-Output -InputObject "Where would you like to install $($moduleName)?"
    $prompt = Read-Host -Prompt "Press Enter to accept [$($Path)] or enter a new path"
    $Path = ($Path, $prompt)[[bool]$prompt]
}

$Path = Join-Path -Path $Path -ChildPath $moduleVersion

if (!(Test-Path -Path $Path))
{
    New-Item -Path $Path -ItemType Directory
}

$fileList | ForEach-Object {
    if ($_[$_.Length - 1] -like '\') {
        New-Item -Path $Path -Name $_ -ItemType Directory
    }
}

$wc = New-Object -TypeName System.Net.WebClient
$fileList | ForEach-Object {
    if ($_[$_.Length - 1] -notlike '\') {
        $webFile   = "$githubBase/$moduleName/master/$_"
        $localFile = "$Path\$_"
        Write-Output -InputObject "Downloading $webFile to $localFile"
        $wc.DownloadFile($webFile, $localFile)
    }
}

Write-Output -InputObject "Add to your script:"
Write-Output -InputObject "Import-Module -Name `"$Path\$moduleName`""
