#
# Windows PowerShell script to create the container for Device Writeback
#

Write-Output "Configuring your Active Directory forest for device writeback from Azure AD"

## Set variables
$selectedForest = "lucernpub.com"
$selectedDomain = "lucernpub.com"
$adConnectorAccount = "lucernpub.com\MSOL_9eee26c52012"
$ldap = "LDAP://"
$rootDSE = New-Object System.DirectoryServices.DirectoryEntry($ldap + "RootDSE")
$configDN = $rootDSE.Properties["configurationNamingContext"][0].ToString()
$servicesDN = "CN=Services," + $configDN
$drcDN = "CN=Device Registration Configuration," + $servicesDN
$drsContainerDN = "CN=Device Registration Services," + $drcDN
$drsObjectDN = "CN=DeviceRegistrationService," + $drsContainerDN
$selectedDomainDn = "DC=lucernpub,DC=com"
$registeredDevicesDN = "CN=RegisteredDevices,DC=lucernpub,DC=com"

## Confirm current forest is selected forest
$currentForest = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest().Name
if ($currentForest -ne $selectedForest)
{
   Write-Output "ERROR: Device Writeback configuration cannot be completed." 
   Write-Output "       The current forest is not the selected forest: $selectedForest"
   Exit 1
}

## Create/Acl: CN=RegisteredDevices container
if ([System.DirectoryServices.DirectoryEntry]::Exists($ldap + $registeredDevicesDN))
{
   $userAcl = $adConnectorAccount + ":GRGWCCDCSDDT"
   dsacls.exe $registeredDevicesDN /G $userAcl /I:T > $null
}
else
{
   $deDefaultNaming = New-Object System.DirectoryServices.DirectoryEntry($ldap + $selectedDomainDn)
   $deRegisteredDevices = $deDefaultNaming.Children.Add("CN=RegisteredDevices", "msDS-DeviceContainer")
   $deRegisteredDevices.CommitChanges()

   $userAcl = $adConnectorAccount + ":GRGWCCDCSDDT"
   dsacls.exe $registeredDevicesDN /G $userAcl /I:T > $null
}

## Create/Acl: CN=Device Registration Configuration,CN=Services
if ([System.DirectoryServices.DirectoryEntry]::Exists($ldap + $drcDN))
{
   $deDRC = New-Object System.DirectoryServices.DirectoryEntry($ldap + $drcDN)
   $userAcl = $adConnectorAccount + ":GRGW"
   dsacls.exe $drcDN /G $userAcl /I:T > $null
}
else
{
   $de = New-Object System.DirectoryServices.DirectoryEntry($ldap + $servicesDN)
   $deDRC = $de.Children.Add("CN=Device Registration Configuration", "container")
   $deDRC.CommitChanges()
   $userAcl = $adConnectorAccount + ":GRGW"
   dsacls.exe $drcDN / G $userAcl / I:T > $null
}

## Edit/Create: CN=Device Registration Services,CN=Device Registration Configuration,CN=Services
if ([System.DirectoryServices.DirectoryEntry]::Exists($ldap + $drsContainerDN))
{
   $deDRSContainer = New-Object System.DirectoryServices.DirectoryEntry($ldap + $drsContainerDN)

   ## Remove - CN=DeviceRegistrationService,CN=Device Registration Services,CN=Device Registration Configuration,CN=Services
   if ([System.DirectoryServices.DirectoryEntry]::Exists($ldap + $drsObjectDN))
   {
       $deDRSObject = New-Object System.DirectoryServices.DirectoryEntry($ldap + $drsObjectDN)
       $deDRSContainer.Children.Remove($deDRSObject)
       $deDRSContainer.CommitChanges()
   }
}
else
{
   $deDRSContainer = $deDRC.Children.Add("CN=Device Registration Services", "msDS-DeviceRegistrationServiceContainer")
   $deDRSContainer.CommitChanges()
}

## Create: CN=DeviceRegistrationService,CN=Device Registration Services,CN=Device Registration Configuration,CN=Services
$deDRSObject = $deDRSContainer.Children.Add("CN=DeviceRegistrationService", "msDS-DeviceRegistrationService")
$deDRSObject.Properties["msDS-DeviceLocation"].Add($registeredDevicesDN) > $null
$deDRSObject.Properties["msDS-IsEnabled"].Add("TRUE") > $null
$deDRSObject.Properties["msDS-MaximumRegistrationInactivityPeriod"].Add(0) > $null

for ($i = 0; $i -le 12; $i++)
{
   try
   {
      $deDRSObject.CommitChanges()
      $Error = $null
      break
   }
   catch
   {
      $Error = "Failed to create the device registration object in Active Directory.  This can happen due to replication latency which is typically 30 - 45 minutes.  Allow for replication to take place and try again later."
   }

   Start-Sleep 5
}

if ($Error)
{
   Write-Output "Configuration could not be completed."
   Write-Output $Error
}
else
{
   Write-Output "Configuration complete!"
}
