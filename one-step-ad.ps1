# variables for the Forest & Domain configuration
$NTDSPath = "C:\Windows\NTDS"
$LogPath = "C:\Windows\NTDS"
$SysVolPath = "C:\Windows\SYSVOL"
$ForestMode = "Win2012R2"
$DomainMode = "WinThreshold"
$DomainName = "local.ntnxdemo.com"
$DomainNetBiosName = "ntnxdemo"
$AdministratorPassword = "Ntnx2017!"

# install domain services on the active machine
Add-WindowsFeature AD-Domain-Services

# install ad management tools
Add-WindowsFeature RSAT-ADDS-Tools

# import ad module
Import-Module ADDSDeployment

# create forest, domain and first dc
# note that this command uses Windows 2016 FDL and DFL
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath $NTDSPath -DomainMode $DomainMode -DomainName $DomainName -DomainNetbiosName $DomainNetBiosName -ForestMode $ForestMode -InstallDns:$true -LogPath $LogPath -NoRebootOnCompletion:$false -SysvolPath: $SysVolPath -Force:$true -SafeModeAdministratorPassword (ConvertTo-SecureString -String $AdministratorPassword -AsPlainText -Force)

# If being run via a Nutanix Calm blueprint, you will need to reboot after this step