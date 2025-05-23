#Requires -RunAsAdministrator

param (
    $configuration = "config.ps1",
	$helpersModule = "scripts\helpers.psm1",
	$mongoModule = "scripts\mongo.psm1",
	$featuresModule = "scripts\features.psm1",
	$deploymentModule = "scripts\deployment.psm1",
	$vcredistExecutable = "execs\vc_redist.x64.exe",
	$mongoExecutable = "execs\mongo.zip",
	$apiBinaries = "binaries\api.zip",
	$websiteBinaries = "binaries\website.zip",
	$dataImportFile = "data\osemosys.zip",
	$bundlerExec = "execs\LegacyDataBundler.exe"
)

$scriptPath = Split-Path $script:MyInvocation.MyCommand.Path

$helpersModulePath = Join-Path -Path $scriptPath -ChildPath $helpersModule
Import-Module $helpersModulePath

$mongoModulePath = Join-Path -Path $scriptPath -ChildPath $mongoModule
Import-Module $mongoModulePath

$featuresModulePath = Join-Path -Path $scriptPath -ChildPath $featuresModule
Import-Module $featuresModulePath

$ErrorActionPreference = "Stop"

$configFile = Join-Path -Path $scriptPath -ChildPath $configuration
. $configFile 

$mongoExecutablePath = Join-Path -Path $scriptPath -ChildPath $mongoExecutable
$vcredistExecutablePath = Join-Path -Path $scriptPath -ChildPath $vcredistExecutable
Install-MongoDb $mongoExecutablePath $mongoDbPath $vcredistExecutablePath

$dataImportFilePath = Join-Path -Path $scriptPath -ChildPath $dataImportFile
$bundlerExecPath = Join-Path -Path $scriptPath -ChildPath $bundlerExec
Import-Data $dataImportFilePath $mongoDbPath
Update-Data $bundlerExecPath

Install-RequiredFeatures

$deploymentModulePath = Join-Path -Path $scriptPath -ChildPath $deploymentModule
Import-Module $deploymentModulePath

$apiBinariesPath = Join-Path -Path $scriptPath -ChildPath $apiBinaries
$websiteBinariesPath = Join-Path -Path $scriptPath -ChildPath $websiteBinaries

Publish-Website "MoManI-api" $apiBinariesPath $apiDirectory $url $apiPort
Publish-Website "MoManI-website" $websiteBinariesPath $websiteDirectory $url $websitePort
