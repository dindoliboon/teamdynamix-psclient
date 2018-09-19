#Requires -Version 3

Set-StrictMode -Version 3

#Continue
#SilentlyContinue
$Script:DebugPreference   = 'SilentlyContinue'
$Script:VerbosePreference = 'SilentlyContinue'

Import-Module -Name "$PSScriptRoot\..\..\..\..\..\teamdynamix-psclient"

InModuleScope teamdynamix-psclient {
    $bearer                 = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1bmlxdWVfbmFtZSI6InVzZXJAbG9jYWwiLCJpc3MiOiJURCIsImF1ZCI6Imh0dHBzOi8vd3d3LnRlYW1keW5hbWl4LmNvbS8iLCJleHAiOjE0NTgwNDg2NTEsIm5iZiI6MTQ1Nzk2MjI1MX0.DYFzy8Q9Nn0sR7fY-28vY8GHhRTn1aFe36BHy9u_J2w'

    <#
        # Generic catch-all. This will throw an exception if we forgot to mock something.
        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient {
            Write-Debug -Message 'Mocked Invoke-WebRequest with no parameter filter.'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"
            Write-Debug -Message "`t[Body]   $Body"

            throw "Unidentified call to Invoke-WebRequest"
        }
    #>

    Describe 'New-TdpscPersonImport' {
        Mock Get-UploadBoundaryEncodedByte -ModuleName teamdynamix-psclient -ParameterFilter {$Path -eq 'TestDrive:\import.xlsx'} {
            Write-Debug -Message 'Get-UploadBoundaryEncodedByte'
            Write-Debug -Message "`t[Path] $Path"

            ''
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Post' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'people/import')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{StatusDescription = 'OK'}
        }

        Context 'Passing with parameter' {
            It 'Accepts -Bearer and -Path' {
                $xlsxFile   = 'TestDrive:\import.xlsx'
                '-no-data-' | Set-Content -Path $xlsxFile

                New-TdpscPersonImport -Bearer $bearer -Path $xlsxFile | Should Be 'OK'
            }
        }

        Context 'Passing bearer from pipeline' {
            It 'Accepts -Path' {
                $xlsxFile   = 'TestDrive:\import.xlsx'
                '-no-data-' | Set-Content -Path $xlsxFile

                $bearer | New-TdpscPersonImport -Path $xlsxFile | Should Be 'OK'
            }
        }

        Context 'Passing without parameter name' {
            It 'Accepts with Bearer and Path (Fails in 1.0.0.5 and earlier)' {
                $xlsxFile   = 'TestDrive:\import.xlsx'
                '-no-data-' | Set-Content -Path $xlsxFile

                New-TdpscPersonImport $bearer $xlsxFile | Should Be 'OK'
            }
        }
    }
}

Remove-Module -Name teamdynamix-psclient
