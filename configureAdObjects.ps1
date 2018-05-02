# groups for Prism & SSP admin & users
$PrismAdminsGroupName = "PrismAdmins"
$PrismUsersGroupName = "PrismUsers"
$SSPAdminsGroupName = "SSPAdmins"
$SSPUSersGroupName = "SSPUsers"

# two accounts - one admin, one non-admin
$ServiceAdminFirstName = "Service"
$ServiceAdminLastName = "Admin"
$ServiceAdminAccount = "service.admin"
$ServiceAdminUser = "service.admin@local.ntnxdemo.com"
$ServiceAdminName = "Service Admin"
$ServiceAdminPassword = "Ntnx2017!"

$NonAdminFirstName = "Jane"
$NonAdminLastName = "Doe"
$NonAdminAccount = "jane.doe"
$NonAdminUser = "jane.doe@local.ntnxdemo.com"
$NonAdminName = "Jane Doe"
$NonAdminPassword = "Nutanix/4u"

# start detailed logging
Start-Transcript -Path "C:\Logs\configureAdOjects-transcript.txt"  -IncludeInvocationHeader -Force

# $Logfile = "C:\Logs\$(gc env:computername)-adObjects.log"

# Function LogWriteObjects
# {
#    Param ([string]$logstring)
#    Add-content $Logfile -value $logstring
# }

$Server = $env:COMPUTERNAME

# LogWriteObjects("Creating AD groups ...")
New-ADGroup -Server $Server -Name $PrismAdminsGroupName -GroupScope DomainLocal
New-ADGroup -Server $Server -Name $PrismUsersGroupName -GroupScope DomainLocal
New-ADGroup -Server $Server -Name $SSPAdminsGroupName -GroupScope DomainLocal
New-ADGroup -Server $Server -Name $SSPUSersGroupName -GroupScope DomainLocal

# LogWriteObjects("Creating AD users ...")
New-ADUser -Server $Server $NonAdminName -SAMAccountName $NonAdminAccount -DisplayName $NonAdminName -GivenName $NonAdminFirstName -Surname $NonAdminLastName -UserPrincipalName $NonAdminUser -PasswordNeverExpires:$true -AccountPassword (ConvertTo-SecureString -AsPlainText $NonAdminPassword -Force) -Enabled:$true
New-ADUser -Server $Server $ServiceAdminName -SAMAccountName $ServiceAdminAccount -DisplayName $ServiceAdminName -GivenName $ServiceAdminFirstName -Surname $ServiceAdminLastName -UserPrincipalName $ServiceAdminUser -PasswordNeverExpires:$true -AccountPassword (ConvertTo-SecureString -AsPlainText $ServiceAdminPassword -Force) -Enabled:$true

# LogWriteObjects("Adding users to groups ...")
$prismAdminsGroup = Get-ADGroup -Server $Server "CN=$PrismAdminsGroupName,CN=Users,DC=local,DC=ntnxdemo,DC=com"
$prismUsersGroup = Get-ADGroup -Server $Server "CN=$PrismUsersGroupName,CN=Users,DC=local,DC=ntnxdemo,DC=com"
$sspAdminsGroup = Get-ADGroup -Server $Server "CN=$SSPAdminsGroupName,CN=Users,DC=local,DC=ntnxdemo,DC=com"
$sspUsersGroup = Get-ADGroup -Server $Server "CN=$SSPUsersGroupName,CN=Users,DC=local,DC=ntnxdemo,DC=com"

$standardUser = Get-ADUser -Server $Server "CN=$NonAdminFirstName $NonAdminLastName,CN=Users,DC=local,DC=ntnxdemo,DC=com"
$adminUser = Get-ADUser -Server $Server "CN=$ServiceAdminFirstName $ServiceAdminLastName,CN=Users,DC=local,DC=ntnxdemo,DC=com"

Add-ADGroupMember -Server $Server $prismAdminsGroup -Members $adminUser
Add-ADGroupMember -Server $Server $sspAdminsGroup -Members $adminUser
Add-ADGroupMember -Server $Server $sspUsersGroup -Members $standardUser
Add-ADGroupMember -Server $Server $prismUsersGroup -Members $standardUser

# LogWriteObjects("Done!")

Stop-Transcript