$ADFSFarmName = "sts.lucernpub.com"
$Thumb = (Get-ChildItem -path cert:\LocalMachine\My | Where-Object {$_.Subject -match $ADFSFarmName}).Thumbprint
Add-AdfsFarmNode -CertificateThumbprint $thumb GroupServiceAccountIdentifier lucernpub.com\ADFSgMSA$ -SQLConnectionString "Data Source=SQL01.lucernpub.com;Integrated Security=True"