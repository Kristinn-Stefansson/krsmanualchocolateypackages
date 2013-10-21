$currFolder = $(Split-Path -parent $MyInvocation.MyCommand.Definition)

# Base setings
$packageName = 'VS2012.Update3'
$version = "11.0.60610.0"
$windowsInstallerName = 'Visual Studio 2012 Update 3 .*'
$installerType = 'EXE' 

$silentArgs = "/Quiet /NoRestart /Log $env:temp\VS2012Update3.$version.log"
$validExitCodes = @(0,3010) 

# Cached image
$imageFile = "VS2013Update3.ISO"
$image = (Join-Path (Join-Path $source "$packageName.$version") "$imageFile")
$copyInstallerToPath = "$env:TEMP\chocolatey\$packageName\$version\$imageFile"
$imageSetup = "VS2012.3.exe"

# Download URL
$url = "http://download.microsoft.com/download/D/4/8/D48D1AC2-A297-4C9E-A9D0-A218E6609F06/VS2012.3.exe" # download url
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
   