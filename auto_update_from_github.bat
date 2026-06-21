@echo off
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0"

set "REMOTE_VERSION_URL=https://raw.githubusercontent.com/heyitshestia/kfps-updater-migration-test/refs/heads/main/VERSION"
set "LOG_DIR=%CD%\runtime\update-logs"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%" >nul 2>nul

set "STAMP=auto"
for /f "delims=" %%T in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd-HHmmss" 2^>nul') do set "STAMP=%%T"
set "LOG_FILE=%LOG_DIR%\auto-update-%STAMP%.log"

call :log "KFPS automatic update check"
call :capture_current_version LOCAL_VERSION
call :log "Local version: !LOCAL_VERSION!"

for /f "usebackq delims=" %%V in (`powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; (Invoke-WebRequest -UseBasicParsing -Uri '%REMOTE_VERSION_URL%' -Headers @{'Cache-Control'='no-cache'; 'User-Agent'='KFPS-AutoUpdate'}).Content.Trim()" 2^>nul`) do (
    set "REMOTE_VERSION=%%V"
)

if not defined REMOTE_VERSION (
    call :log "GitHub version check unavailable. Skipping."
    exit /b 0
)
call :log "GitHub main version: !REMOTE_VERSION!"

if /i "!LOCAL_VERSION!"=="!REMOTE_VERSION!" (
    call :log "Already up to date. Skipping."
    exit /b 0
)

call :check_running
if errorlevel 1 (
    call :log "KFPS is currently running. Skipping automatic update."
    exit /b 0
)

call :log "Update available. Running safe unattended updater..."
set "FORZA_PAINTER_NO_PAUSE=1"
set "KFPS_UPDATE_SKIP_IF_RUNNING=1"
call "%CD%\03_update_from_github.bat"
set "UPDATE_EXIT=%ERRORLEVEL%"
call :log "Updater exited with code !UPDATE_EXIT!."
exit /b !UPDATE_EXIT!

:capture_current_version
set "%~1=unknown"
if exist "VERSION" (
    for /f "usebackq delims=" %%V in ("VERSION") do (
        set "%~1=%%V"
        goto :capture_current_version_done
    )
)
:capture_current_version_done
exit /b 0

:check_running
set "RUNNING_REPORT=%TEMP%\kfps-auto-update-running-%RANDOM%.txt"
if exist "!RUNNING_REPORT!" del /f /q "!RUNNING_REPORT!" >nul 2>nul
set "KFPS_RUNNING_REPORT=!RUNNING_REPORT!"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$root=(Resolve-Path '.').Path; $report=$env:KFPS_RUNNING_REPORT; $names=@('KloudysGalateaGenesis.exe','KloudysGeneratorV7.exe','KloudysGeneratorV6.exe','KloudysGeneratorV6-Go.exe','KloudysGeneratorV5.exe','KloudysGeneratorV5DetailLock.exe','KloudysGeneratorV4.exe','KloudysGeneratorV2.exe','KloudysGeneratorV2Fast.exe','KloudysGeneratorV2Speed.exe','ForzaVinylStudio.exe'); $match={ ($names -contains $_.Name) -or (($_.Name -match '^python') -and ($_.CommandLine -like ('*' + $root + '*')) -and ($_.CommandLine -match 'app_qt.py|launcher_qt.py|start_fabric_editor.py|forza_generator_v2.py|benchmark_generator_settings.py')) }; $locks=Get-CimInstance Win32_Process | Where-Object $match; if($locks){ $locks | ForEach-Object { ('PID ' + $_.ProcessId + ' - ' + $_.Name) } | Set-Content -LiteralPath $report -Encoding ASCII; exit 1 }; exit 0"
if errorlevel 1 (
    if exist "!RUNNING_REPORT!" (
        call :log "Running process details:"
        for /f "usebackq delims=" %%L in ("!RUNNING_REPORT!") do call :log "%%L"
        del /f /q "!RUNNING_REPORT!" >nul 2>nul
    )
    exit /b 1
)
if exist "!RUNNING_REPORT!" del /f /q "!RUNNING_REPORT!" >nul 2>nul
exit /b 0

:log
if "%~1"=="" (
    echo.
    >> "%LOG_FILE%" echo.
) else (
    echo %~1
    >> "%LOG_FILE%" echo [%DATE% %TIME%] %~1
)
exit /b 0
