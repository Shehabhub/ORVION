@echo off
REM Thin launcher — verify the workstation. Real logic lives in .workstation\doctor.ps1.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0.workstation\doctor.ps1"
pause
