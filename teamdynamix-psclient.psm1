#Requires -Version 3

Set-StrictMode -Version 3

ForEach ($import in (Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'lib\*.ps1') -Recurse | Where-Object -FilterScript { -not ($_.FullName -like '*.tests.*') }))
{
    Try
    {
        # Using dot source with *.ps1 instead of Import-Module with *.psm1.
        # Multi-nested modules ignore -Verbose & -Debug parameters.
        Write-Verbose -Message "Loading module from path '$($import.FullName)'."
        . $import.FullName
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.FullName): $_"
    }
}
