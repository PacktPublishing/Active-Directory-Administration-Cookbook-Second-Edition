$conn = New-Object System.Data.SqlClient.SqlConnection 
$conn.ConnectionString = "Data Source=SQL01.lucernpub.com:Port;Integrated Security=True" 
# If no error occurs here, then connection was successful. 
$conn.Open(); 
$conn.Close();