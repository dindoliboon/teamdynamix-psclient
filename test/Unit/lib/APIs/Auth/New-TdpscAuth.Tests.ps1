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

    Describe 'New-TdpscAuth' {
        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Post' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'auth')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{Content = $bearer}
        }

        Context 'Passing with parameter' {
            It 'Accepts -Credential' {
                $userName   = 'test@domain.local'
                $password   = 'not-very-secure' | ConvertTo-SecureString -AsPlainText -Force
                $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $userName, $password

                New-TdpscLoginSession -Credential $credential | Should Not BeNullOrEmpty

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
            }
        }

        Context 'Passing without parameter name' {
            It 'Accepts Credential' {
                $userName   = 'test@domain.local'
                $password   = 'not-very-secure' | ConvertTo-SecureString -AsPlainText -Force
                $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $userName, $password

                New-TdpscLoginSession $credential | Should Not BeNullOrEmpty

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
            }
        }

        Context 'Passing from pipeline' {
            It 'Accepts Credential' {
                $userName   = 'test@domain.local'
                $password   = 'not-very-secure' | ConvertTo-SecureString -AsPlainText -Force
                $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $userName, $password

                $credential | New-TdpscLoginSession | Should Not BeNullOrEmpty

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
            }
        }
    }
}

Remove-Module -Name teamdynamix-psclient
