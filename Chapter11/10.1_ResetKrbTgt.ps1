Set-ADAccountPassword -Identity (Get-ADUser krbtgt).DistinguishedName -Reset -NewPassword (ConvertTo-SecureString "Rand0mCompl3xP@ssw0rd!" -AsPlainText -Force)