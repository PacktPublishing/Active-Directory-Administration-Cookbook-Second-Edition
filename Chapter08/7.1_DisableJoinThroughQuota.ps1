Import-Module ActiveDirectory
Set-ADDomain -Identity Lucernpub.com -Replace @{"ms-DS-MachineAccountQuota"="0"}