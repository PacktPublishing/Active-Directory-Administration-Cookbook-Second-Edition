Set-ADObject -Identity "CN=NTDS Site Settings,CN=Default-First-SiteName,CN=Sites,CN=Configuration,DC=LucernPub,DC=com" -Replace @{interSiteTopologyGenerator="CN=NTDS Settings,CN=DC01,CN=Servers,CN=Default-First-Site-Name,CN=Sites,CN=Configuration,DC=LucernPub,DC=com"} 