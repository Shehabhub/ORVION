@echo off
REM Single workstation entry — thin launcher over .workstation\menu.ps1 (interactive menu).
REM AI agents: call .workstation\prepare.ps1 (etc.) directly; the menu waits for input.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0.workstation\menu.ps1"
