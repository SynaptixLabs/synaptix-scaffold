@echo off
title KB Sync
echo.
echo  =============================================
echo   KB Sync
echo  =============================================
echo.
if "%~1"=="" (
    echo   No filters — syncing ALL files
    echo.
    powershell -ExecutionPolicy Bypass -File "%~dp0sync-kb.ps1"
) else (
    echo   Args: %*
    echo.
    powershell -ExecutionPolicy Bypass -File "%~dp0sync-kb.ps1" %*
)
echo.
echo Press any key to close...
pause >nul
