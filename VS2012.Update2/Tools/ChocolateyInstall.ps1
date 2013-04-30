$packageName = 'VS2012.Update2'
$windowsInstallerName = 'Visual Studio 2012 Update 2 .*'
$installerType = 'EXE' 
# $url = 'C:\Disks\DownloadedMSDN\VS2012\Visual Studio 2012 Update 2\VS2012.2.exe' # download url
$url = 'http://download.microsoft.com/download/7/8/8/78863D92-FAA5-4692-8B51-381901E9BE7F/VS2012.2.exe' # download url
$url64 = $url # 64bit URL uses the same as $url
$silentArgs = "/Quiet /NoRestart /Log VS2012_U2.log"
$validExitCodes = @(0,3010) 
try {
	# installer, will assert administrative rights
	$isInstalled = Stop-OnAppIsInstalled $packageName $windowsInstallerName
	if($isInstalled -eq $false) {
		Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes
	}
} catch {
  Write-ChocolateyFailure $packageName $($_.Exception.Message)
  throw
}
