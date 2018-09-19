#Requires -Version 3

Set-StrictMode -Version 3

#Continue
#SilentlyContinue
$Script:DebugPreference   = 'SilentlyContinue'
$Script:VerbosePreference = 'SilentlyContinue'

Import-Module -Name "$PSScriptRoot\..\..\..\..\..\teamdynamix-psclient"

InModuleScope teamdynamix-psclient {
    $bearer       = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1bmlxdWVfbmFtZSI6InVzZXJAbG9jYWwiLCJpc3MiOiJURCIsImF1ZCI6Imh0dHBzOi8vd3d3LnRlYW1keW5hbWl4LmNvbS8iLCJleHAiOjE0NTgwNDg2NTEsIm5iZiI6MTQ1Nzk2MjI1MX0.DYFzy8Q9Nn0sR7fY-28vY8GHhRTn1aFe36BHy9u_J2w'

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

    Describe 'New-TdpscAuthLoginSso' {
        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Get' -and $URI -eq (((Get-TdpscApiBaseAddress) -replace '/app.', '/sandbox.') + 'auth/loginsso')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"
            Write-Debug -Message "`t[Body]   $Body"

            [PSCustomObject]@{InputFields = @{name='test1'; value='test1'}, @{name='test2'; value='test2'}}
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Post' -and $URI -eq 'https://shib.teamdynamix.com/Shibboleth.sso/SAML2/POST'} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"
            Write-Debug -Message "`t[Body]   $Body"

            [PSCustomObject]@{Content = $bearer}
        }

        Context 'Examples' {
            It 'Accepts -WebClient WebRequest' {
                $idpSession = New-Object -TypeName Microsoft.PowerShell.Commands.WebRequestSession
                $result = New-TdpscAuthLoginSso -DomainName 'sandbox' -WebClient 'WebRequest' -WebSession ([ref]$idpSession)

                $result | Should Be $bearer
                $result.GetType().FullName | Should Be 'System.String'
                { $result.Count } | Should Throw
            }

            It 'Fails -WebClient WebBrowser with invalid domain (not mocked)' {
                $result = New-TdpscAuthLoginSso -DomainName 'sandbox'

                $result | Should Be $null
            }

            It 'Fails -WebClient InternetExplorer with invalid domain (not mocked)' {
                $result = New-TdpscAuthLoginSso -DomainName 'sandbox' -WebClient 'InternetExplorer'

                $result | Should Be $null
            }
        }
    }
}

Remove-Module -Name teamdynamix-psclient
