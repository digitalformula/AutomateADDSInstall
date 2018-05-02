# PowerShell scripts to automate the installation of Active Directory

Very basic script to install AD services and then create a directory with some default objects.
Please check your requirements before running these scripts as not every option is configured via variables.

Assumes basic knowledge of PowerShell.

## Requirements

- Windows 2016 VM w/ all latest updates applied
- Sysprep run on the Windows 2016 VM to avoid duplicate SID issues

## Assumptions

- No existing AD Domain matching the name stored in 'one-step-ad.ps1' (edit to suit your needs)