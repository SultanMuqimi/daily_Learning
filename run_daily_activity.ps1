# Daily Activity Automation Script for Windows (PowerShell)
# This script runs the Python activity tracker

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Daily Learning Activity Tracker" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Change to script directory
Set-Location -Path $PSScriptRoot

# Check if Python is installed
try {
    $pythonVersion = python --version 2>&1
    Write-Host "Found: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Python is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Python from https://www.python.org/" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# Run the Python script
Write-Host ""
Write-Host "Running activity tracker..." -ForegroundColor Yellow
$result = python daily_activity.py

# Check exit code
if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "SUCCESS: Activity tracker completed successfully!" -ForegroundColor Green
    exit 0
} else {
    Write-Host ""
    Write-Host "ERROR: Activity tracker failed. Check activity_log.txt for details." -ForegroundColor Red
    exit 1
}
