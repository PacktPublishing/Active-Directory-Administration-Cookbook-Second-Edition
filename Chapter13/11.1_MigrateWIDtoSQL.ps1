New-Item “C:\ADFSSQLScript” -Type Directory
Export-AdfsDeploymentSQLScript -DestinationFolder “C:\ADFSSQLScript” -ServiceAccountName LUCERNPUB\ADFSgMSA$

Stop-Service adfssrv
$connection = New-Object -TypeName System.Data.SqlClient.SqlConnection
$connection.ConnectionString = ‘Server=np:\.pipeMICROSOFT##WIDtsqlquery;Database=master;Trusted_Connection=True;’
$connection.Open()
$command = $connection.CreateCommand()
$command.CommandText = “EXEC sp_detach_db @dbname = N’AdfsArtifactStore’;”
$result = $command.ExecuteReader()
$connection.close()
$connection.Open()
$command = $connection.CreateCommand()
$command.CommandText = “EXEC sp_detach_db @dbname = N’AdfsConfigurationV4’;”
$result = $command.ExecuteReader()
$connection.close()

$Conn= Get-WmiObject -namespace root/ADFS -class SecurityTokenService
$Conn.ConfigurationdatabaseConnectionstring=”data source=SQL01.lucernpub.com; initial catalog=adfsconfiguration;integrated security=true”
$Conn.put()

Start-Service adfssrv
Set-adfsproperties –artifactdbconnection “data source= SQL01.lucernpub.com; initial catalog=adfsartifactstore;integrated security=true”
Restart-Service adfssrv

Uninstall-WindowsFeature Windows-Internal-Database