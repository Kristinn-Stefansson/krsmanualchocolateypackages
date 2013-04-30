$packageName = 'VS2012.Update1'
$windowsInstallerName = 'Visual Studio 2012 Update 1 .*'
$installerType = 'EXE' 
$url = 'C:\Disks\DownloadedMSDN\VS2012\Visual Studio 2012 Update 1\vsupdate_KB2707250.exe' # download url
$url64 = $url # 64bit URL uses the same as $url
$silentArgs = "/Quiet /NoRestart /NoWeb /Log $env:temp\vs2012_U1.log"
$validExitCodes = @(0,3010) 

try
{
	$isInstalled = Stop-OnAppIsInstalled $packageName $windowsInstallerName
	if($isInstalled -eq $false) {
		# installer, will assert administrative rights
		Start-ChocolateyProcessAsAdmin -statements $silentArgs -exeToRun "$url" -validExitCodes $validExitCodes
		Write-ChocolateySuccess $packageName
	}
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
   