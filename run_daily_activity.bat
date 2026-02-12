@echo off
REM Daily Activity Automation Script for Windows
REM This script runs the Python activity tracker

echo ========================================
echo Daily Learning Activity Tracker
echo ========================================
echo.

REM Change to script directory
cd /d "%~dp0"

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python from https://www.python.org/
    pause
    exit /b 1
)

REM Run the Python script
echo Running activity tracker...
python daily_activity.py

REM Check exit code
if errorlevel 1 (
    echo.
    echo ERROR: Activity tracker failed. Check activity_log.txt for details.
    exit /b 1
) else (
    echo.
    echo SUCCESS: Activity tracker completed successfully!
)

REM Uncomment the line below if you want to keep the window open
REM pause

exit /b 0
