$currFolder = $(Split-Path -parent $MyInvocation.MyCommand.Definition)

# Base setings
$packageName = 'VS2012.Pro'
$version = "11.0.50727.1"
$windowsInstallerName = 'Microsoft Visual Studio Professional 2012'
$installerType = 'EXE' 
$adminFile = (Join-Path $currFolder 'AdminDeployment.xml')
$silentArgs = "/Quiet /NoRestart /AdminFile $adminFile /Log $env:temp\$packageName.$version.$version.log"
$validExitCodes = @(0,3010) 

# Cached image
$imageFile = "en_visual_studio_professional_2012_x86_dvd_2262334.iso"
$image = (Join-Path (Join-Path $source "$packageName.$version") "$imageFile")
$copyInstallerToPath = "$env:TEMP\chocolatey\$packageName\$version\$imageFile"
$imageSetup = "vs_Professional.exe"

# Download URL
$url = "http://download.microsoft.com/download/D/E/8/DE8E42D8-7598-4F4E-93D4-BB011094E2F9/vs_professional.exe" # download url
$url64 = $url # 64bit URL uses the same as $url

$isInstalled = Stop-OnAppIsInstalled $packageName $windowsInstallerName
if($isInstalled -eq $false) {
	if(Test-Path $image)
	{
		Get-ChocolateyWebFile $packageName $copyInstallerToPath $image
		$driveLetter = Mount-Iso -isopath $copyInstallerToPath
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
