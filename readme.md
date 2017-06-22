# PowerShell scripts to automate the installation of Active Directory

Assumes basic knowledge of PowerShell.

## Requirements

- Windows 2016 VM w/ all latest updates applied
- Sysprep run on the Windows 2016 VM to avoid duplicate SID issues

## Assumptions

- No existing AD Domain matching the name stored in 'installAd.ps1' (edit to suit your needs)