Import-Module Active Directory
Set-ADAccountControl -Identity User -HomedirRequired $true