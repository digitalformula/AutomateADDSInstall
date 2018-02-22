Start-Transcript -Path "C:\Logs\configureAdOjects-transcript.txt"  -IncludeInvocationHeader -Force

# $Logfile = "C:\Logs\$(gc env:computername)-adObjects.log"

# Function LogWriteObjects
# {
#    Param ([string]$logstring)
#    Add-content $Logfile -value $logstring
# }

$Server = $env:COMPUTERNAME

# LogWriteObjects("Creating AD groups ...")
New-ADGroup -Server $Server -Name "PrismAdmins" -GroupScope DomainLocal
New-ADGroup -Server $Server -Name "PrismUsers" -GroupScope DomainLocal
New-ADGroup -Server $Server -Name "SSPAdmins" -GroupScope DomainLocal
New-ADGroup -Server $Server -Name "SSPUsers" -GroupScope DomainLocal

# LogWriteObjects("Creating AD users ...")
New-ADUser -Server $Server "Jane Doe" -SAMAccountName "jane.doe" -DisplayName "Jane Doe" -GivenName "Jane" -Surname "Doe" -UserPrincipalName "jane.doe@local.ntnxdemo.com" -PasswordNeverExpires:$true -AccountPassword (ConvertTo-SecureString -AsPlainText "Ntnx2017!" -Force) -Enabled:$true
New-ADUser -Server $Server "Service Admin" -SAMAccountName "service.admin" -DisplayName "Service Admin" -GivenName "Service" -Surname "Admin" -UserPrincipalName "service.admin@local.ntnxdemo.com" -PasswordNeverExpires:$true -AccountPassword (ConvertTo-SecureString -AsPlainText "Ntnx2017!" -Force) -Enabled:$true

# LogWriteObjects("Adding users to groups ...")
$prismAdminsGroup = Get-ADGroup -Server $Server "CN=PrismAdmins,CN=Users,DC=local,DC=ntnxdemo,DC=com"
$prismUsersGroup = Get-ADGroup -Server $Server "CN=PrismUsers,CN=Users,DC=local,DC=ntnxdemo,DC=com"
$sspAdminsGroup = Get-ADGroup -Server $Server "CN=SSPAdmins,CN=Users,DC=local,DC=ntnxdemo,DC=com"
$sspUsersGroup = Get-ADGroup -Server $Server "CN=SSPUsers,CN=Users,DC=local,DC=ntnxdemo,DC=com"

$standardUser = Get-ADUser -Server $Server "CN=Jane Doe,CN=Users,DC=local,DC=ntnxdemo,DC=com"
$adminUser = Get-ADUser -Server $Server "CN=Service Admin,CN=Users,DC=local,DC=ntnxdemo,DC=com"

Add-ADGroupMember -Server $Server $prismAdminsGroup -Members $adminUser
Add-ADGroupMember -Server $Server $sspAdminsGroup -Members $adminUser
Add-ADGroupMember -Server $Server $sspUsersGroup -Members $standardUser
Add-ADGroupMember -Server $Server $prismUsersGroup -Members $standardUser

# LogWriteObjects("Done!")

Stop-Transcript