Import-Module Microsoft.Graph 
Connect-MgGraph -scopes RoleManagement.Read.Directory,User.ReadBasic.All

$roles = Get-MgDirectoryRole
ForEach($role in $roles) {
 $users = Get-MgDirectoryRoleMember -DirectoryRoleId $role.Id
 ForEach($user in $users) {
 $Hashtable =[ordered]@{
  RoleName = $role.DisplayName
  userPrincipalName = $user.AdditionalProperties.userPrincipalName
  }
  [PSCustomObject]$Hashtable
 }
} 
