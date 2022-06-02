$replicationSchedule = New-Object -TypeName System.DirectoryServices.ActiveDirectory.ActiveDirectorySchedule 
$replicationSchedule.SetDailySchedule("Eight","Zero","Seventeen","Zero")
Set-ADReplicationSiteLink DEFAULTIPSITELINK -ReplicationSchedule $replicationSchedule 