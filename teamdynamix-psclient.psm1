#Requires -Version 3

Set-StrictMode -Version 3

Add-Type -AssemblyName System.Web
Add-Type -AssemblyName Microsoft.PowerShell.Commands.Utility
Add-Type -AssemblyName System.Web.Extensions

ForEach ($import in (Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'lib\*.ps1') -Recurse | Where-Object -FilterScript { $_.FullName -like '*.internal.ps1' }))
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

ForEach ($import in (Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'lib\*.ps1') -Recurse | Where-Object -FilterScript { -not ($_.FullName -like '*.tests.*') -and -not ($_.FullName -like '*.internal.ps1') }))
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

Set-TdpscApiBaseAddress -Target 'Production'
