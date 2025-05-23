$scriptPath = Split-Path $script:MyInvocation.MyCommand.Path
$ErrorActionPreference = "Stop"

function Install-MongoDb($mongoExecutable, $mongoDbPath, $vcredistExecutablePath) 
{
	if ((Test-Path -path $mongoDbPath) -eq $True) 
	{ 
		Write-Host "Seems you have already installed MongoDB"
		& net start mongodb
		Return 
	}

	Write-Host "Setting up MongoDB"
	
	Start-Process -FilePath $vcredistExecutablePath -ArgumentList “/passive” -Wait -Passthru
	
	New-Item -ItemType Directory -Force -Path $mongoDbPath
	
	Expand-ZipFile $mongoExecutable $mongoDbPath
	
	New-Item -ItemType Directory -Force -Path $mongoDbPath/log
	New-Item -ItemType Directory -Force -Path $mongoDbPath/data
	New-Item -ItemType Directory -Force -Path $mongoDbPath/data/db
	
	$mongoDbConfigPath = "$mongoDbPath\mongod.cfg"
	[System.IO.File]::AppendAllText("$mongoDbConfigPath", "dbpath=$mongoDbPath\data\db`r`n")
	[System.IO.File]::AppendAllText("$mongoDbConfigPath", "logpath=$mongoDbPath\log\mongo.log`r`n")
	
	& $mongoDbPath\bin\mongod.exe --config $mongoDbConfigPath --install
	& net start mongodb
	
	Write-Host "MongoDB successfully installed and started"
}

function Import-Data($dataImportFile, $mongoDbPath) 
{
	$confirmation = Read-Host "Do you want to import OSEMOSyS data to your database? Existing data may be overwritten. Press y/n"
	if ($confirmation -eq 'y') {
	  
		$confirmation2 = Read-Host "Do you want to remove all current MoManI data? Press y/n"
		if ($confirmation2 -eq 'y') {
			Write-Host "Removing existing MoManI data"
			$mongoExePath = Join-Path -Path $mongoDbPath -ChildPath bin/mongo.exe
			& $mongoExePath momani --eval "db.dropDatabase()"
		}
		
		Write-Host "Importing MoManI data"
		$tempFolder = [System.IO.Path]::GetTempPath()
		$dataTempFolder = Join-Path -Path $tempFolder -ChildPath momani-data
		Expand-ZipFile $dataImportFile $dataTempFolder
		& $mongoDbPath\bin\mongorestore.exe --db momani $dataTempFolder/momani
		Remove-Directory $dataTempFolder
	}
}

function Update-Data($bunderExec) 
{
	Start-Process -FilePath $bunderExec -ArgumentList "momani" -NoNewWindow -Wait -PassThru;
}

function Export-Data($mongoDbPath, $exportDirectory) 
{
	& $mongoDbPath\bin\mongodump.exe -d momani /o $exportDirectory
}
