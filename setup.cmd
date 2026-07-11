@echo off
REM Thin launcher — human double-click convenience. Real logic lives in .workstation\prepare.ps1.
REM AI agents: call .workstation\prepare.ps1 directly (no pause).
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0.workstation\prepare.ps1"
pause
