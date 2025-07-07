# Full network isolation with automatic restoration after 60 seconds
# Run as administrator

$scriptName = "isolate-then-restore"
$log_file = "C:\Program Files (x86)\ossec-agent\active-response\wazuh_isolation.log"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

function Write-WazuhLog {
    param([string]$message)
    $line = "$timestamp ${scriptName}: $message"
    Add-Content -Path $log_file -Value $line
}

Write-Host "Starting network isolation..." -ForegroundColor Cyan
Write-WazuhLog "Machine isolated"
Write-WazuhLog "Network isolation started"

# Get active adapters
$activeAdapters = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }

if ($activeAdapters.Count -eq 0) {
    Write-Host "No active adapters found to disable." -ForegroundColor Yellow
    Write-WazuhLog "No active adapters found"
    exit
}

foreach ($adapter in $activeAdapters) {
    try {
        Write-Host "Disabling interface: $($adapter.Name)" -ForegroundColor Green
        Disable-NetAdapter -Name $adapter.Name -Confirm:$false -ErrorAction Stop
        $msg = "Interface '$($adapter.Name)' disabled"
        Write-WazuhLog $msg
    }
    catch {
        $msg = "ERROR disabling interface '$($adapter.Name)': $_"
        Write-Host $msg -ForegroundColor Red
        Write-WazuhLog $msg
    }
}

Write-WazuhLog "All active interfaces disabled"
Write-Host "`nWaiting 60 seconds before restoring..." -ForegroundColor Yellow

# Countdown
for ($i = 60; $i -gt 0; $i--) {
    Write-Host ("Restoring in {0} seconds..." -f $i).PadRight(45) -NoNewline
    Start-Sleep -Seconds 1
    Write-Host "`r" -NoNewline
}

Write-Host "`nStarting interface restoration..." -ForegroundColor Cyan
Write-WazuhLog "Restoring interfaces..."

foreach ($adapter in $activeAdapters) {
    try {
        Enable-NetAdapter -Name $adapter.Name -Confirm:$false -ErrorAction Stop
        Restart-NetAdapter -Name $adapter.Name -Confirm:$false -ErrorAction Stop
        $msg = "Interface '$($adapter.Name)' successfully restored"
        Write-Host $msg -ForegroundColor Green
        Write-WazuhLog $msg
    }
    catch {
        $msg = "ERROR restoring interface '$($adapter.Name)': $_"
        Write-Host $msg -ForegroundColor Red
        Write-WazuhLog $msg
    }
}

Write-WazuhLog "Restoration completed"
Write-WazuhLog "Connection restored"
Write-Host "`nRestoration completed. Network should be active again." -ForegroundColor Cyan
