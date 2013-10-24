# Check if we are running on windows 8 with native commands.
if ((Get-Command "Mount-DiskImage" -errorAction SilentlyContinue) -eq $false)
{
	$addCertificate = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)\addCertificate.ps1"
	Start-ChocolateyProcessAsAdmin "& `'$addCertificate`'"  

	$currFolder = $(Split-Path -parent $MyInvocation.MyCommand.Definition)

	# Base setings
	$packageName = 'Arion.VirtualCloneDrive'
	$version = "5.4.7.0"
	$windowsInstallerName = 'VirtualCloneDrive'
	$installerType = 'EXE' 
	$silentArgs = "/S /noreboot"
	$validExitCodes = @(0,3010) 

	# Cached image
	$imageFile = "SetupVirtualCloneDrive5470.exe"
	$image = (Join-Path (Join-Path $source "$packageName.$version") "$imageFile")
	$copyInstallerToPath = "$env:TEMP\chocolatey\$packageName\$version\$imageFile"

	# Download URL
	$url = "http://static.slysoft.com/SetupVirtualCloneDrive.exe" # download url
	$url64 = $url # 64bit URL uses the same as $url

	if(Test-Path $image)
	{
		New-Item -ItemType Directory -Force -Path $(Split-Path -parent $copyInstallerToPath)
		Get-ChocolateyWebFile $packageName $copyInstallerToPath $image
		# installer, will assert administrative rights
		Start-ChocolateyProcessAsAdmin -statements $silentArgs -exeToRun "$copyInstallerToPath" -validExitCodes $validExitCodes
	}
	else
	{
		# installer, will assert administrative rights
		Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes
	}
}
else
{	
  Write-ChocolateySuccess 'Arion.VirtualCloneDrive'
}