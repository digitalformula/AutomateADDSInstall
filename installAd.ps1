Write-Host 'Creating post-reboot scheduled task ...'
$configureAdAction = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument "-ExecutionPolicy Bypass -File ""C:\Scripts\configureAd.ps1"""
# $configureAdUserName = New-ScheduledTaskPrincipal -UserID "Administrator" -LogonType Password -RunLevel Highest
$configureAdUserName = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
$configureAdTrigger  = New-ScheduledTaskTrigger -AtStartup
$configureAdSettings = New-ScheduledTaskSettingsSet
$configureAdTask = New-ScheduledTask -Action $configureAdAction -Principal $configureAdUserName -Trigger $configureAdTrigger -Settings $configureAdSettings
Register-ScheduledTask ConfigureAD -InputObject $configureAdTask -Force -Password "nutanix/4u" -User "Administrator"

Write-Host 'Installing Git for Windows ...'
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
choco install git.install -y -params "/GitAndUnixToolsOnPath"
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")

mkdir C:\Logs
mkdir C:\Scripts
git clone https://github.com/digitalformula/AutomateADDSInstall.git C:\Scripts -q

Write-Host "Installing AD Domain Services ..."
Add-WindowsFeature AD-Domain-Services
Write-Host "Installing AD Domain Services Tools ..."
Add-WindowsFeature RSAT-ADDS-Tools
Write-Host "Importing ADDS Deployment Module ..."
Import-Module ADDSDeployment
Write-Host "Creating AD Forest, Domain and first DC ..."
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "Win2012R2" -DomainName "local.ntnxdemo2.com" -DomainNetbiosName "ntnxdemo2" -ForestMode "Win2012R2" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$false -SysvolPath: "C:\Windows\SYSVOL" -Force:$true -SafeModeAdministratorPassword (ConvertTo-SecureString -String "nutanix/4u" -AsPlainText -Force)