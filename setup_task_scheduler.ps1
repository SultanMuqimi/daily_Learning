# Task Scheduler Setup Script
# Run this script as Administrator to set up automated daily commits

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Daily Learning - Task Scheduler Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    Write-Host "Please right-click and select 'Run as Administrator'" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# Get script directory
$scriptDir = $PSScriptRoot
$scriptPath = Join-Path $scriptDir "run_daily_activity.bat"

# Task details
$taskName = "DailyLearningActivity"
$taskDescription = "Automatically updates GitHub activity daily"

# Check if task already exists
$existingTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue

if ($existingTask) {
    Write-Host "Task '$taskName' already exists." -ForegroundColor Yellow
    $response = Read-Host "Do you want to replace it? (Y/N)"
    if ($response -ne "Y" -and $response -ne "y") {
        Write-Host "Setup cancelled." -ForegroundColor Yellow
        exit 0
    }
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
    Write-Host "Removed existing task." -ForegroundColor Green
}

# Ask for preferred time
Write-Host ""
Write-Host "When would you like the daily activity to run?" -ForegroundColor Cyan
$hour = Read-Host "Enter hour (0-23, default is 10)"
if ([string]::IsNullOrWhiteSpace($hour)) { $hour = "10" }

$minute = Read-Host "Enter minute (0-59, default is 0)"
if ([string]::IsNullOrWhiteSpace($minute)) { $minute = "0" }

# Create scheduled task action
$action = New-ScheduledTaskAction -Execute $scriptPath -WorkingDirectory $scriptDir

# Create trigger (daily at specified time)
$trigger = New-ScheduledTaskTrigger -Daily -At ([DateTime]::Today.AddHours($hour).AddMinutes($minute))

# Create settings
$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -RunOnlyIfNetworkAvailable `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 10)

# Register the task
try {
    Register-ScheduledTask `
        -TaskName $taskName `
        -Description $taskDescription `
        -Action $action `
        -Trigger $trigger `
        -Settings $settings `
        -User $env:USERNAME `
        -RunLevel Limited `
        -Force | Out-Null
    
    Write-Host ""
    Write-Host "SUCCESS! Task created successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Task Details:" -ForegroundColor Cyan
    Write-Host "  Name: $taskName" -ForegroundColor White
    Write-Host "  Time: Daily at $($hour):$($minute)" -ForegroundColor White
    Write-Host "  Script: $scriptPath" -ForegroundColor White
    Write-Host ""
    Write-Host "You can view/edit this task in Task Scheduler:" -ForegroundColor Yellow
    Write-Host "  1. Press Win + R" -ForegroundColor White
    Write-Host "  2. Type: taskschd.msc" -ForegroundColor White
    Write-Host "  3. Look for '$taskName' in Task Scheduler Library" -ForegroundColor White
    Write-Host ""
    
    $runNow = Read-Host "Would you like to test the task now? (Y/N)"
    if ($runNow -eq "Y" -or $runNow -eq "y") {
        Write-Host ""
        Write-Host "Running task now..." -ForegroundColor Yellow
        Start-ScheduledTask -TaskName $taskName
        Start-Sleep -Seconds 3
        Write-Host "Check activity_log.txt for results." -ForegroundColor Cyan
    }
    
} catch {
    Write-Host ""
    Write-Host "ERROR: Failed to create scheduled task!" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

Write-Host ""
Read-Host "Press Enter to exit"
