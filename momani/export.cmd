powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "& '%~dp0\RunExport.ps1' %*"
exit /B %errorlevel%
