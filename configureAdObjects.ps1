$Logfile = "C:\Logs\$(gc env:computername)-adObjects.log"

Function LogWrite
{
   Param ([string]$logstring)
   Add-content $Logfile -value $logstring
}

$Server = $env:COMPUTERNAME

LogWrite("Creating AD groups ...")
New-ADGroup -Server $Server -Name "PrismAdmins" -GroupScope DomainLocal
New-ADGroup -Server $Server -Name "SSPAdmins" -GroupScope DomainLocal
New-ADGroup -Server $Server -Name "SSPUsers" -GroupScope DomainLocal

LogWrite("Creating AD users ...")
New-ADUser -Server $Server "Nutanix User" -SAMAccountName "nutanix.user" -DisplayName "Nutanix User" -GivenName "Nutanix" -Surname "User" -UserPrincipalName "nutanix.user@local.ntnxdemo6.com" -PasswordNeverExpires:$true -AccountPassword (ConvertTo-SecureString -AsPlainText "Ntnx2017!" -Force) -Enabled:$true
New-ADUser -Server $Server "Jane Doe" -SAMAccountName "jane.doe" -DisplayName "Jane Doe" -GivenName "Jane" -Surname "Doe" -UserPrincipalName "jane.doe@local.ntnxdemo6.com" -PasswordNeverExpires:$true -AccountPassword (ConvertTo-SecureString -AsPlainText "Ntnx2017!" -Force) -Enabled:$true

LogWrite("Adding admin user to groups ...")
$prismGroup = Get-ADGroup -Server $Server "CN=PrismAdmins,CN=Users,DC=local,DC=ntnxdemo6,DC=com"
$sspAdminsGroup = Get-ADGroup -Server $Server "CN=SSPAdmins,CN=Users,DC=local,DC=ntnxdemo6,DC=com"
$sspUsersGroup = Get-ADGroup -Server $Server "CN=SSPUsers,CN=Users,DC=local,DC=ntnxdemo6,DC=com"
$user = Get-ADUser -Server $Server "CN=Nutanix User,CN=Users,DC=local,DC=ntnxdemo6,DC=com"
Add-ADGroupMember -Server $Server $prismGroup -Members $user
Add-ADGroupMember -Server $Server $SSPAdminsGroup -Members $user

LogWrite("Adding non-admin user to groups ...")
$sspUsersGroup = Get-ADGroup -Server $Server "CN=SSPUsers,CN=Users,DC=local,DC=ntnxdemo6,DC=com"
$user = Get-ADUser -Server $Server "CN=Jane Doe,CN=Users,DC=local,DC=ntnxdemo6,DC=com"
Add-ADGroupMember -Server $Server $sspUsersGroup -Members $user

LogWrite("Removing scheduled task ...")
Unregister-ScheduledTask "ConfigureAD" -Confirm:$false

LogWrite("Done!")