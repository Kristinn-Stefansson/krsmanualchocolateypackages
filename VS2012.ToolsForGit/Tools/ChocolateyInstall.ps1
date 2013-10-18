$packageName = 'VS2012.ToolsForGit'
$windowsInstallerName = 'Visual Studio Tools for Git.*'
$installerType = 'MSI' 
# $url = 'C:\Disks\DownloadedMSDN\VS2012\Visual Studio 2012 Update 2\VS2012.2.exe' # download url
$url = 'http://visualstudiogallery.msdn.microsoft.com/abafc7d6-dcaa-40f4-8a5e-d6724bdb980c/file/93137/6/Microsoft.TeamFoundation.Git.Provider.msi' # download url
$url64 = $url # 64bit URL uses the same as $url
$silentArgs = "/Quiet /NoRestart /Log VS2012ToolsForGit.log"
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
