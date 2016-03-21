#Requires -Version 3

Set-StrictMode -Version 3

$Script:DebugPreference   = 'SilentlyContinue'
$Script:VerbosePreference = 'SilentlyContinue'

Clear-Host

# Install-Module -Name PSScriptAnalyzer -Repository PSGallery

Import-Module -Name PSScriptAnalyzer

# Get-Module -Name PSScriptAnalyzer -ListAvailable

Invoke-ScriptAnalyzer -Path "$PSScriptRoot\.." -Recurse | Format-Table
