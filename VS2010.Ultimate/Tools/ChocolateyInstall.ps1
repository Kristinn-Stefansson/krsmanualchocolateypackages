$currFolder = $(Split-Path -parent $MyInvocation.MyCommand.Definition)

# Base setings
$packageName = 'VS2010.Ultimate'
$version = "10.0.30319.1"
$windowsInstallerName = 'Microsoft Visual Studio Ultimate 2010'
$installerType = 'EXE' 
$adminFile = (Join-Path $currFolder 'Deployment.ini')
$silentArgs = "/Q /NoRestart /UnattendFile $adminFile /Log $env:temp\vs2010.$version.log"
$validExitCodes = @(0,3010) 

# Cached image
$imageFile = "en_visual_studio_2010_ultimate_x86_dvd_509116.iso"
$image = (Join-Path (Join-Path $source "$packageName.$version") "$imageFile")
$copyInstallerToPath = "$env:TEMP\chocolatey\$packageName\$version\$imageFile"
$imageSetup = "Setup\Setup.exe"

# Download URL
$url = "" # download url
$url64 = $url # 64bit URL uses the same as $url

$isInstalled = Stop-OnAppIsInstalled $packageName $windowsInstallerName
if($isInstalled -eq $false) {
	if(Test-Path $image)
	{
		# Get-ChocolateyWebFile $packageName $copyInstallerToPath $image
		$driveLetter = Open-MountedIso -isopath $image
		$exeToRun = (Join-Path $driveLetter "$imageSetup")
		try
		{
			# installer, will assert administrative rights
			Start-ChocolateyProcessAsAdmin -statements $silentArgs -exeToRun "$exeToRun" -validExitCodes $validExitCodes
		}
		finally
		{
			Close-MountedIso $driveLetter
		}
	}
	else
	{
		# installer, will assert administrative rights
		Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes
	}
}
