Start-Transcript -Path "C:\Logs\configureAd-transcript.txt")

$Logfile = "C:\Logs\$(gc env:computername)-stage.log"

Function LogWrite
{
   Param ([string]$logstring)
   Add-content $Logfile -value $logstring
}

LogWrite("Waiting 5 minutes ...")
Start-Sleep -s 300

LogWrite("Setting up credentials ...")
$password = ConvertTo-SecureString "nutanix/4u" -AsPlainText -Force
LogWrite("Password created")
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "ntnxdemo8\administrator",$password
LogWrite("Credential created")

LogWrite("Running AD object creation script ...")
Start-Process powershell.exe -Credential $credential -NoNewWindow -ArgumentList "-File C:\Scripts\configureAdObjects.ps1"
LogWrite("Process finished!")