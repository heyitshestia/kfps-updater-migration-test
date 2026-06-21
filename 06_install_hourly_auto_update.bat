@echo off
setlocal EnableExtensions
cd /d "%~dp0"

set "TASK_LOGON=KFPS Auto Update At Logon"
set "TASK_HOURLY=KFPS Auto Update Hourly"
set "WORKER=%~dp0auto_update_from_github.bat"

if not exist "%WORKER%" (
    echo Missing auto update worker:
    echo %WORKER%
    pause
    exit /b 1
)

echo Installing KFPS automatic update checks for the current Windows user...
echo.
echo This creates two scheduled tasks:
echo - %TASK_LOGON%
echo - %TASK_HOURLY%
echo.
echo The worker checks GitHub, skips if KFPS is already up to date, and skips if
echo KFPS, the generator, or the editor is currently running.
echo.

schtasks /Create /F /TN "%TASK_LOGON%" /SC ONLOGON /TR "\"%WORKER%\"" >nul
if errorlevel 1 (
    echo Failed to create logon task.
    pause
    exit /b 1
)

schtasks /Create /F /TN "%TASK_HOURLY%" /SC HOURLY /MO 1 /ST 00:00 /TR "\"%WORKER%\"" >nul
if errorlevel 1 (
    echo Failed to create hourly task.
    pause
    exit /b 1
)

echo Automatic update checks are installed.
echo Logs are written to runtime\update-logs.
pause
exit /b 0
