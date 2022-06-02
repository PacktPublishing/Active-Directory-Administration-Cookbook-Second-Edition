Set-ADObject -Identity "CN=Group,OU=OrganizationalUnit,DC=lucernPub,DC=com" -ProtectedFromAccidentalDeletion $False
Remove-ADObject -Identity "CN=Group,OU=Organizational Unit,DC=lucernPub,DC=com"
