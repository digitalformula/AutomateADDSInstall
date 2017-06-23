Start-Transcript -Path "C:\Logs\configureAd-transcript.txt" -IncludeInvocationHeader -Force

# $Logfile = "C:\Logs\$(gc env:computername)-stage.log"

# Function LogWrite
# {
#    Param ([string]$logstring)
#    Add-content $Logfile -value $logstring
# }

# LogWrite("Waiting 5 minutes ...")
Start-Sleep -s 300

# LogWrite("Setting up credentials ...")
# $password = ConvertTo-SecureString "nutanix/4u" -AsPlainText -Force
# LogWrite("Password created")
# $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "ntnxdemo10\administrator",$password
$credential = New-Object System.Management.Automation.PSCredential ('ntnxdemo10\administrator', (ConvertTo-SecureString 'nutanix/4u' -AsPlainText -Force))
# LogWrite("Credential created")

# LogWrite("Running AD object creation script ...")
Start-Process powershell.exe -Credential $credential -NoNewWindow -ArgumentList "-File C:\Scripts\configureAdObjects.ps1"

# Start-Process powershell -Credential $pp -ArgumentList '-noprofile -command &{Start-Process $script -verb runas}'

# LogWrite("Process finished!")

Stop-Transcript