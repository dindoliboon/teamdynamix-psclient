#Requires -Version 4

#
# PowerShell module for interacting with the TeamDynamix Web API 9.3
#
# http://www.apache.org/licenses/LICENSE-2.0
#

# Locate any PowerShell scripts under the lib folder.
(Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'lib\*.ps1') -Recurse) | ForEach-Object {
    # Using dot source with *.ps1 instead of Import-Module with *.psm1.
    # Multi-nested modules ignore -Verbose & -Debug parameters.
    . $_.FullName
}
