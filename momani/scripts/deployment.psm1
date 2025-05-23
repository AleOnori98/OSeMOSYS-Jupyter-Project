$scriptPath = Split-Path $script:MyInvocation.MyCommand.Path
$ErrorActionPreference = "Stop"
Import-Module WebAdministration

function Publish-Website($name, $zipFile, $websiteDirectory, $deployUrl, $port)
{
	if(Test-Path IIS:\Sites\$name)  
	{
		Remove-WebSite $name
	}
	if(Test-Path IIS:\AppPools\$name)  
	{
		Remove-WebAppPool $name
	}
	Expand-ZipFile $zipFile $websiteDirectory
	New-Item IIS:\AppPools\$name
	New-Website -name $name -PhysicalPath $websiteDirectory -Port $port -ApplicationPool $name -HostHeader $deployUrl  
}
