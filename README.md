# 🔐 Windows Network Isolation Script

This repository contains two scripts designed to **temporarily isolate a Windows host from the network** during incident response scenarios. It is ideal for integration with SIEM/SOAR platforms such as Wazuh or for manual use in corporate and lab environments.

## 📜 Description

- `isolate-then-restore.ps1`: PowerShell script that disables all active network interfaces, logs activity in a Wazuh-compatible format, and automatically restores the connection after 60 seconds.
- `isolate-wrapper.bat`: A batch script that runs the PowerShell script from the user's desktop with elevated permissions.

## ⚙️ Requirements

- Windows 10/11 or Windows Server 2016+
- Administrator privileges
- PowerShell 5.1+
- Wazuh agent installed (optional for log monitoring)

## 🛠️ Script Location & Behavior
## 📁 Script Path
By default, the batch wrapper isolate-wrapper.bat is configured to run the PowerShell script from the user’s Desktop:
powershell -NoProfile -ExecutionPolicy Bypass -File "%USERPROFILE%\Desktop\isolate-then-restore.ps1"

For proper integration with Wazuh, it is recommended to place the script in the official Wazuh agent directory:
C:\Program Files (x86)\ossec-agent\active-response\bin\

Then, update the batch file to point to the new location:
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Program Files (x86)\ossec-agent\active-response\bin\isolate-then-restore.ps1"

## 🔄 Optional: Prevent automatic reconnection
By default, the script restores all network adapters after 60 seconds to avoid permanent isolation in manual test scenarios.
If you want to use this script for true one-way isolation, such as during real threats, you should remove or comment out the restoration block, which starts here:
Write-Host "`nWaiting 60 seconds before restoring..." -ForegroundColor Yellow

and ends here:
Write-WazuhLog "Connection restored"
Write-Host "`nRestoration completed. Network should be active again." -ForegroundColor Cyan
This way, the host will remain isolated until manually reconnected by an analyst.


## 📂 Log location

Logs are written to: C:\Program Files (x86)\ossec-agent\active-response\wazuh_isolation.log

This log can be monitored by Wazuh to trigger alerts or automatic ticket creation via integrations.

## 🚀 Quick usage

1. Place both files on the Desktop.
2. Double-click `isolate-wrapper.bat`.
3. The system will isolate itself from the network for 60 seconds and restore it automatically.

## 👤 Author

Created by **Gerardo Cáceres**  
Cybersecurity specialist and open-source SOC solutions engineer.

## 📝 License

This project is released under a **permissive Opensource license**.  
You are free to use, modify, and redistribute it without restrictions. Attribution is appreciated.
