$scriptPath = Split-Path $script:MyInvocation.MyCommand.Path
$ErrorActionPreference = "Stop"

function Install-RequiredFeatures() 
{
	Write-Host "Installing WebServer Windows feature"
	Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-WebServerRole
	Write-Host "Installing ASP.NET 4.5 Windows feature"
	Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-ASPNET45
	Write-Host "All feature installations completed"
}