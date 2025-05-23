#Requires -RunAsAdministrator

param (
    $configuration = "config.ps1",
	$helpersModule = "scripts\helpers.psm1",
	$mongoModule = "scripts\mongo.psm1",
	$dataExportDirectory = "exported",
	$dataExportFilename = "osemosys.zip"
)

$scriptPath = Split-Path $script:MyInvocation.MyCommand.Path

$helpersModulePath = Join-Path -Path $scriptPath -ChildPath $helpersModule
Import-Module $helpersModulePath

$mongoModulePath = Join-Path -Path $scriptPath -ChildPath $mongoModule
Import-Module $mongoModulePath

$ErrorActionPreference = "Stop"

$configFile = Join-Path -Path $scriptPath -ChildPath $configuration
. $configFile 

Export-Data $mongoDbPath $dbExportDirectory 

$dataExportDirectoryPath = Join-Path -Path $scriptPath -ChildPath $dataExportDirectory
$dataExportFilePath = Join-Path -Path $dataExportDirectoryPath -ChildPath $dataExportFilename
Remove-Directory $dataExportDirectoryPath
New-Item -ItemType Directory -Force -Path $dataExportDirectoryPath

Compress-ZipFile $dbExportDirectory\momani $dataExportFilePath
Remove-Directory $dbExportDirectory
