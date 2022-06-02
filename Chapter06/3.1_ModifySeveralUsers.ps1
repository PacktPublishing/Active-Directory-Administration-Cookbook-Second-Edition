Import-Module ActiveDirectory
Get-ADUser -ldapfilter "(sAMAccountName=service_*)" | Set-ADObject ProtectedFromAccidentalDeletion $true