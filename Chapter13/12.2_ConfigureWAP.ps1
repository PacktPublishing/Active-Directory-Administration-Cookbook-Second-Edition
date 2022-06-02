$ADFSFarmName = "sts.lucernpub.com"
$Thumb = (Get-ChildItem -path cert:\LocalMachine\My | Where-Object {$_.Subject -match $ADFSFarmName}).Thumbprint 
Install-WebApplicationProxy -CertificateThumbprint $Thumb -FederationServiceName $ADFSFarmName