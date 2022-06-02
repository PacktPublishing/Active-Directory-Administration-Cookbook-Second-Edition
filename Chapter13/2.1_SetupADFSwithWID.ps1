New-ADServiceAccount -Name ADFSgMSA -DNSHostName DC01.lucernpub.com

$ADFSFarmName = "sts.lucernpub.com"

$Thumb = (Get-ChildItem -path cert:\LocalMachine\My | Where-Object {$_.Subject -match $ADFSFarmName}).Thumbprint 

Install-AdfsFarm -CertificateThumbprint $thumb -FederationServiceName $ADFSFarmName -GroupServiceAccountIdentifier lucernpub.com\ADFSgMSA$