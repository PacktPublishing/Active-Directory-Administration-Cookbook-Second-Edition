$cred = Get-Credential
Import-Module ADFS
Update-AdfsArtifactDatabasePermission -Credential $cred 

Set-AdfsProperties -ExtranetLockoutThreshold 10
Set-AdfsProperties -ExtranetObservationWindow (New-Timespan -minutes 5)
Set-AdfsProperties -EnableExtranetLockout $true
Set-AdfsProperties -ExtranetLockoutMode AdfsSmartLockoutEnforce
Restart-Service adfssrv