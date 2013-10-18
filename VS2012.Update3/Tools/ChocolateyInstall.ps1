$currFolder = $(Split-Path -parent $MyInvocation.MyCommand.Definition)

$packageName = 'VS2012.Update3'
$deploymentFile = "VS2013Update3.ISO"
$copyInstallerToPath = "$env:TEMP\chocolatey\$packageName\$deploymentFile"
$windowsInstallerName = 'Visual Studio 2012 Update 3 .*'
$installerType = 'EXE' 
$url = (Join-Path (Join-Path $source "$packageName.11.0.60610.0") "$deploymentFile") # download url
$url64 = $url # 64bit URL uses the same as $url
$silentArgs = "/Quiet /NoRestart /Log $env:temp\VS2012Update3.log"
$validExitCodes = @(0,3010) 

try
{
	$isInstalled = Stop-OnAppIsInstalled $packageName $windowsInstallerName
	if($isInstalled -eq $false) {
		Get-ChocolateyWebFile $packageName $copyInstallerToPath $url
		$driveLetter = Mount-Iso -isopath $copyInstallerToPath
		$exeToRun = (Join-Path $driveLetter "VS2012.3.exe")
		# installer, will assert administrative rights
		Start-ChocolateyProcessAsAdmin -statements $silentArgs -exeToRun "$exeToRun" -validExitCodes $validExitCodes
		Write-ChocolateySuccess $packageName
		Dismount-Iso $driveLetter
	}
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
	Dismount-Iso $driveLetter
    throw
}
   