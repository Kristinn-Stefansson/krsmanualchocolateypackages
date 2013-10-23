$currFolder = $(Split-Path -parent $MyInvocation.MyCommand.Definition)

# Base setings
$packageName = 'VS2013.Ultimate'
$version = "12.0.21005.1"
$windowsInstallerName = 'Microsoft Visual Studio Ultimate 2013'
$installerType = 'EXE' 
$adminFile = (Join-Path $currFolder 'AdminDeployment.xml')
$silentArgs = "/Quiet /NoRestart /AdminFile $adminFile /Log $env:temp\vs2013.$version.log"
$validExitCodes = @(0,3010) 

# Cached image
$imageFile = "en_visual_studio_ultimate_2013_x86_dvd_3009107.iso"
$image = (Join-Path (Join-Path $source "$packageName.$version") "$imageFile")
$copyInstallerToPath = "$env:TEMP\chocolatey\$packageName\$version\$imageFile"
$imageSetup = "vs_ultimate.exe"

# Download URL
$url = "http://download.microsoft.com/download/C/F/B/CFBB5FF1-0B27-42E0-8141-E4D6DA0B8B13/vs_ultimate.exe" # download url
$url64 = $url # 64bit URL uses the same as $url

$isInstalled = Stop-OnAppIsInstalled $packageName $windowsInstallerName
if($isInstalled -eq $false) {
	if(Test-Path $image)
	{
		# Get-ChocolateyWebFile $packageName $copyInstallerToPath $image
		$driveLetter = Mount-Iso -isopath $image
		$exeToRun = (Join-Path $driveLetter "$imageSetup")
		try
		{
			# installer, will assert administrative rights
			Start-ChocolateyProcessAsAdmin -statements $silentArgs -exeToRun "$exeToRun" -validExitCodes $validExitCodes
		}
		finally
		{
			Dismount-Iso $driveLetter
		}
	}
	else
	{
		# installer, will assert administrative rights
		Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes
	}
}
