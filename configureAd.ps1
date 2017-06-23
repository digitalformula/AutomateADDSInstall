$Logfile = "C:\Logs\$(gc env:computername)-stage.log"

Function LogWrite
{
   Param ([string]$logstring)
   Add-content $Logfile -value $logstring
}

LogWrite("Waiting 2 minutes ...")
Start-Sleep -s 120

LogWrite("Setting up credentials ...")
$password = ConvertTo-SecureString "nutanix/4u" -AsPlainText -Force
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "ntnxdemo5\administrator",$password

LogWrite("Running AD object creation script ...")
Start-Process powershell.exe -Credential $credential -NoNewWindow -ArgumentList "-File C:\Scripts\configureAdObjects.ps1"