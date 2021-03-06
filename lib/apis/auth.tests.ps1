#Requires -Version 3

Set-StrictMode -Version 3

#Continue
#SilentlyContinue
$Script:DebugPreference   = 'SilentlyContinue'
$Script:VerbosePreference = 'SilentlyContinue'

Import-Module -Name "$PSScriptRoot\..\..\teamdynamix-psclient"

InModuleScope teamdynamix-psclient {
    $bearer       = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1bmlxdWVfbmFtZSI6InVzZXJAbG9jYWwiLCJpc3MiOiJURCIsImF1ZCI6Imh0dHBzOi8vd3d3LnRlYW1keW5hbWl4LmNvbS8iLCJleHAiOjE0NTgwNDg2NTEsIm5iZiI6MTQ1Nzk2MjI1MX0.DYFzy8Q9Nn0sR7fY-28vY8GHhRTn1aFe36BHy9u_J2w'
    $restAdminGet = '{"UID":"313f362a-b885-4ea9-996a-6cc9c9eb039b","BEID":"f23d3f8a-a752-4468-8fe2-dedb60a370b7","BEIDInt":190,"IsActive":true,"FullName":"API User","FirstName":"API","LastName":"User","MiddleName":"","Birthday":"0001-01-01T05:00:00Z","Salutation":"","Nickname":"","DefaultAccountID":0,"DefaultAccountName":"None","PrimaryEmail":"","AlternateEmail":"","ExternalID":"","AlternateID":"","Applications":["TDAdmin"],"SecurityRoleName":"","SecurityRoleID":"","Permissions":[],"OrgApplications":[],"GroupIDs":[],"ReferenceID":1000000,"AlertEmail":"","Company":"","Title":"","HomePhone":"","PrimaryPhone":"","WorkPhone":"","Pager":"","OtherPhone":"","MobilePhone":"","Fax":"","DefaultPriorityID":0,"DefaultPriorityName":"None","AboutMe":null,"WorkAddress":"","WorkCity":"","WorkState":"","WorkZip":"","WorkCountry":"","HomeAddress":"","HomeCity":"","HomeState":"","HomeZip":"","HomeCountry":"","DefaultRate":0.0,"CostRate":0.0,"IsEmployee":true,"WorkableHours":8.0,"IsCapacityManaged":false,"ReportTimeAfterDate":"0001-01-01T00:00:00Z","EndDate":"0001-01-01T00:00:00Z","ShouldReportTime":false,"ReportsToUID":"","ReportsToFullName":"","ResourcePoolID":-1,"ResourcePoolName":"","TZID":2,"TZName":"(GMT-05:00)Eastern Time(US and Canada)","TypeID":3,"AuthenticationUserName":"","AuthenticationProviderID":0,"Attributes":[],"Gender":0,"IMProvider":"","IMHandle":""}'

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

    Describe 'Get-TdpscAuth' {
        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Get' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'auth/getuser')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{Content = $restAdminGet}
        }

        Context 'Passing with parameter' {
            It 'Accepts -Bearer' {
                Get-TdpscLoginSession -Bearer $bearer | Should Not BeNullOrEmpty

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
            }

            It 'Fails with empty -Bearer' {
                {Get-TdpscLoginSession -Bearer ''} | Should Throw

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 0 -Scope It
            }

            It 'Fails with null -Bearer' {
                {Get-TdpscLoginSession -Bearer $null} | Should Throw

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 0 -Scope It
            }
        }

        Context 'Passing from pipeline' {
            It 'Accepts Bearer' {
                $bearer | Get-TdpscLoginSession | Should Not BeNullOrEmpty

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
            }
        }

        Context 'Passing without parameter name' {
            It 'Accepts Bearer' {
                Get-TdpscLoginSession $bearer | Should Not BeNullOrEmpty

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
            }

            It 'Fails with empty Bearer' {
                {Get-TdpscLoginSession ''} | Should Throw

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 0 -Scope It
            }

            It 'Fails with null Bearer' {
                {Get-TdpscLoginSession $null} | Should Throw

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 0 -Scope It
            }
        }

        Context 'Return type check' {
            It 'Accepts -Bearer, returns type PSCustomObject' {
                (Get-TdpscLoginSession -Bearer $bearer).GetType().FullName | Should Be 'System.Management.Automation.PSCustomObject'

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
            }
        }
    }

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

    Describe 'New-TdpscAuthCached' {
        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Get' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'auth/getuser')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{Content = $restAdminGet}
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Post' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'auth')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{Content = $bearer}
        }

        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Post' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'auth/loginadmin')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{Content = $bearer}
        }

        Context 'Using user session' {
            It 'Accepts information from file using -UserNameFile, -PasswordFile, -BearerFile, and -IsAdminCredential' {
                $userNameFile = 'TestDrive:\credentials-user.username.txt'
                $passwordFile = 'TestDrive:\credentials-user.password.txt'
                $bearerFile   = 'TestDrive:\credentials-user.bearer.txt'

                'test@domain.local' | Set-Content -Path $userNameFile
                'not-very-secure' | ConvertTo-SecureString -AsPlainText -Force | Out-File -FilePath $passwordFile
                $bearer | Set-Content -Path $bearerFile

                New-TdpscCachedLoginSession -UserNameFile $userNameFile -PasswordFile $passwordFile -BearerFile $bearerFile -IsAdminCredential $false | Should Not BeNullOrEmpty

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
            }
        }

        Context 'Using admin session' {
            It 'Accepts information from file using -UserNameFile, -PasswordFile, -BearerFile, and -IsAdminCredential' {
                $userNameFile = 'TestDrive:\credentials-admin.username.txt'
                $passwordFile = 'TestDrive:\credentials-admin.password.txt'
                $bearerFile   = 'TestDrive:\credentials-admin.bearer.txt'

                'test@domain.local' | Set-Content -Path $userNameFile
                'not-very-secure' | ConvertTo-SecureString -AsPlainText -Force | Out-File -FilePath $passwordFile
                $bearer | Set-Content -Path $bearerFile

                New-TdpscCachedLoginSession -UserNameFile $userNameFile -PasswordFile $passwordFile -BearerFile $bearerFile -IsAdminCredential $true | Should Not BeNullOrEmpty

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
            }
        }

        Context 'Passing without parameter name' {
            It 'Fails with UserNameFile, PasswordFile, BearerFile, and IsAdminCredential' {
                $userNameFile = 'TestDrive:\credentials-admin.username.txt'
                $passwordFile = 'TestDrive:\credentials-admin.password.txt'
                $bearerFile   = 'TestDrive:\credentials-admin.bearer.txt'

                'test@domain.local' | Set-Content -Path $userNameFile
                'not-very-secure' | ConvertTo-SecureString -AsPlainText -Force | Out-File -FilePath $passwordFile
                $bearer | Set-Content -Path $bearerFile

                {New-TdpscCachedLoginSession $userNameFile $passwordFile $bearerFile $true} | Should Throw
            }
        }
    }

    Describe 'New-TdpscAuthLogin' {
        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Post' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'auth/login')} {
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

                New-TdpscAuthLogin -Credential $credential | Should Not BeNullOrEmpty

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
            }
        }

        Context 'Passing without parameter name' {
            It 'Accepts Credential' {
                $userName   = 'test@domain.local'
                $password   = 'not-very-secure' | ConvertTo-SecureString -AsPlainText -Force
                $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $userName, $password

                New-TdpscAuthLogin $credential | Should Not BeNullOrEmpty

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
            }
        }

        Context 'Passing from pipeline' {
            It 'Accepts Credential' {
                $userName   = 'test@domain.local'
                $password   = 'not-very-secure' | ConvertTo-SecureString -AsPlainText -Force
                $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $userName, $password

                $credential | New-TdpscAuthLogin | Should Not BeNullOrEmpty

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
            }
        }
    }

    Describe 'New-TdpscAuthLoginAdmin' {
        Mock Invoke-WebRequest -ModuleName teamdynamix-psclient -ParameterFilter {$Method -eq 'Post' -and $URI -eq ((Get-TdpscApiBaseAddress) + 'auth/loginadmin')} {
            Write-Debug -Message 'Mocked Invoke-WebRequest'
            Write-Debug -Message "`t[Method] $Method"
            Write-Debug -Message "`t[URI]    $URI"

            [PSCustomObject]@{Content = $bearer}
        }

        Context 'Passing with parameter' {
            It 'Accepts -Credential' {
                $userName   = 'f23d3f8a-a752-4468-8fe2-dedb60a370b7'
                $password   = '3ba8bdc8-8d09-4a4d-b4b0-1ac03e90422d' | ConvertTo-SecureString -AsPlainText -Force
                $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $userName, $password

                New-TdpscLoginAdminSession -Credential $credential | Should Not BeNullOrEmpty

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
            }
        }

        Context 'Passing without parameter name' {
            It 'Accepts Credential' {
                $userName   = 'f23d3f8a-a752-4468-8fe2-dedb60a370b7'
                $password   = '3ba8bdc8-8d09-4a4d-b4b0-1ac03e90422d' | ConvertTo-SecureString -AsPlainText -Force
                $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $userName, $password

                New-TdpscLoginAdminSession $credential | Should Not BeNullOrEmpty

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
            }
        }

        Context 'Passing from pipeline' {
            It 'Accepts Credential' {
                $userName   = 'f23d3f8a-a752-4468-8fe2-dedb60a370b7'
                $password   = '3ba8bdc8-8d09-4a4d-b4b0-1ac03e90422d' | ConvertTo-SecureString -AsPlainText -Force
                $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $userName, $password

                $credential | New-TdpscLoginAdminSession | Should Not BeNullOrEmpty

                Assert-MockCalled -CommandName Invoke-WebRequest -Exactly -Times 1 -Scope It
            }
        }
    }

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
