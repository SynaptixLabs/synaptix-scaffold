@echo off
title {{PROJECT_NAME}} KB Sync
echo.
echo  =============================================
echo   {{PROJECT_NAME}} KB Sync
echo  =============================================
echo.
if "%~1"=="" (
    powershell -ExecutionPolicy Bypass -File "%~dp0sync-kb.ps1"
) else (
    echo   Args: %*
    echo.
    powershell -ExecutionPolicy Bypass -File "%~dp0sync-kb.ps1" %*
)
echo.
echo Press any key to close...
pause >nul
