$Logfile = "C:\Logs\$(gc env:computername).log"

Function LogWrite
{
   Param ([string]$logstring)
   Add-content $Logfile -value $logstring
}

LogWrite("Waiting 2 minutes ...")
Start-Sleep -s 120

LogWrite("Creating AD groups ...")
New-ADGroup -Name "PrismAdmins" -GroupScope DomainLocal
New-ADGroup -Name "SSPAdmins" -GroupScope DomainLocal
New-ADGroup -Name "SSPUsers" -GroupScope DomainLocal

LogWrite("Creating AD users ...")
New-ADUser "Nutanix User" -SAMAccountName "nutanix.user" -DisplayName "Nutanix User" -GivenName "Nutanix" -Surname "User" -UserPrincipalName "nutanix.user@local.ntnxdemo2.com" -PasswordNeverExpires:$true -AccountPassword (ConvertTo-SecureString -AsPlainText "Ntnx2017!" -Force) -Enabled:$true
New-ADUser "Jane Doe" -SAMAccountName "jane.doe" -DisplayName "Jane Doe" -GivenName "Jane" -Surname "Doe" -UserPrincipalName "jane.doe@local.ntnxdemo2.com" -PasswordNeverExpires:$true -AccountPassword (ConvertTo-SecureString -AsPlainText "Ntnx2017!" -Force) -Enabled:$true

LogWrite("Adding admin user to groups ...")
$prismGroup = Get-ADGroup "CN=PrismAdmins,CN=Users,DC=local,DC=ntnxdemo2,DC=com"
$sspAdminsGroup = Get-ADGroup "CN=SSPAdmins,CN=Users,DC=local,DC=ntnxdemo2,DC=com"
$sspUsersGroup = Get-ADGroup "CN=SSPUsers,CN=Users,DC=local,DC=ntnxdemo2,DC=com"
$user = Get-ADUser "CN=Nutanix User,CN=Users,DC=local,DC=ntnxdemo2,DC=com"
Add-ADGroupMember $prismGroup -Members $user
Add-ADGroupMember $SSPAdminsGroup -Members $user

LogWrite("Adding non-admin user to groups ...")
$sspUsersGroup = Get-ADGroup "CN=SSPUsers,CN=Users,DC=local,DC=ntnxdemo2,DC=com"
$user = Get-ADUser "CN=Jane Doe,CN=Users,DC=local,DC=ntnxdemo2,DC=com"
Add-ADGroupMember $sspUsersGroup -Members $user

LogWrite("Removing scheduled task ...")
Unregister-ScheduledTask "ConfigureAD" -Confirm:$false

LogWrite("Done!")