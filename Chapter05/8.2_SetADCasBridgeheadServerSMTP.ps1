Set-ADObject -Identity "CN=DC1,CN=Servers,CN=Default-First-SiteName,CN=Sites,CN=Configuration,DC=LucernPub,DC=com" -Add @{bridgeHeadTransportList="CN=SMTP,CN=Inter-Site Transports,CN=Sites,CN=Configuration,DC=LucernPub,DC=com"} 