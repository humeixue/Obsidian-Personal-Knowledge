@echo off
set "SCRIPT=%~dp0项目进度记录.ps1"
powershell.exe -NoProfile -ExecutionPolicy Bypass -STA -File "%SCRIPT%"
