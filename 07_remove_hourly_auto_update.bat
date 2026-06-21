@echo off
setlocal EnableExtensions

set "TASK_LOGON=KFPS Auto Update At Logon"
set "TASK_HOURLY=KFPS Auto Update Hourly"

echo Removing KFPS automatic update scheduled tasks...
schtasks /Delete /F /TN "%TASK_LOGON%" >nul 2>nul
schtasks /Delete /F /TN "%TASK_HOURLY%" >nul 2>nul

echo Done. If Windows says a task did not exist, that is safe to ignore.
pause
exit /b 0
