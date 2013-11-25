$currFolder = $(Split-Path -parent $MyInvocation.MyCommand.Definition)

# Base setings
$packageName = 'VS2008.Suite'
$version = "9.0.21022.8"
$windowsInstallerName = 'Microsoft Visual Studio 2008*'
$installerType = 'EXE' 
$adminFile = (Join-Path $currFolder 'Deployment.ini')
$silentArgs = "/Q /NoRestart /unattendfile $adminFile /Log $env:temp\VS2008.$version.log"
$validExitCodes = @(0,3010) 

# Cached image
$imageFile = "en_visual_studio_team_system_2008_team_suite_x86_x64wow_dvd_X14-26461.iso"
$image = (Join-Path (Join-Path $source "$packageName.$version") "$imageFile")
$imageSetup = "Setup\Setup.exe"

# Download URL
$url = "" # download url
$url64 = $url # 64bit URL uses the same as $url

$isInstalled = Stop-OnAppIsInstalled $packageName $windowsInstallerName
if($isInstalled -eq $false) {
	if(Test-Path $image)
	{
		"Mount:  $image"
		$driveLetter = Open-MountedIso -isopath "$image"
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
