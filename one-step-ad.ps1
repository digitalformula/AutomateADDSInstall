# install domain services on the active machine
Add-WindowsFeature AD-Domain-Services

# install ad management tools
Add-WindowsFeature RSAT-ADDS-Tools

# import ad module
Import-Module ADDSDeployment

# create forest, domain and first dc
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "Win2012R2" -DomainName "local.ntnxdemo.com" -DomainNetbiosName "ntnxdemo" -ForestMode "Win2012R2" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$false -SysvolPath: "C:\Windows\SYSVOL" -Force:$true -SafeModeAdministratorPassword (ConvertTo-SecureString -String "Ntnx2017!" -AsPlainText -Force)