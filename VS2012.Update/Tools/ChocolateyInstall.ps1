$packageName = 'VS2012.Update'
$windowsInstallerName = 'Visual Studio 2012 Update 3 .*'
$installerType = 'EXE' 
# $url = 'C:\Disks\DownloadedMSDN\VS2012\Visual Studio 2012 Update 2\VS2012.2.exe' # download url
$url = 'http://download.microsoft.com/download/D/4/8/D48D1AC2-A297-4C9E-A9D0-A218E6609F06/VS2012.3.exe' # download url
$url64 = $url # 64bit URL uses the same as $url
$silentArgs = "/Quiet /NoRestart /Log VS2012_U3.log"
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
