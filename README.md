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
