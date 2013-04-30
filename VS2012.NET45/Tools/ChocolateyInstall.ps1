$packageName = 'VS2012.NET45'
$windowsInstallerName = 'Microsoft .NET Framework 4.5'
$installerType = 'EXE' 
$url = 'C:\Disks\DownloadedMSDN\VS2012\Microsoft Visual Studio 2012 Ultimate\en_visual_studio_ultimate_2012_x86_dvd_920947\packages\dotNetFramework\dotNetFx45_Full_x86_x64.exe' # download url
$url64 = $url # 64bit URL uses the same as $url
$silentArgs = "/q /norestart /ChainingPackage ""ADMINDEPLOYMENT"" /Log $env:temp\net45.log"
$validExitCodes = @(0) 

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
   