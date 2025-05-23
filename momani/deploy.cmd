powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "& '%~dp0\RunDeploy.ps1' %*"
exit /B %errorlevel%
