Import-Module Active Directory
Set-ADAccountControl -Identity User -PasswordNotRequired $true