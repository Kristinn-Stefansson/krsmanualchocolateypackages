$currFolder = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$adminFile = (Join-Path $currFolder 'AdminDeployment.xml')

$packageName = 'VS2013.Ultimate'
$deploymentFile = "en_visual_studio_ultimate_2013_x86_dvd_3009107.iso"
$copyInstallerToPath = "$env:TEMP\chocolatey\$packageName\$deploymentFile"
$windowsInstallerName = 'Microsoft Visual Studio Ultimate 2013'
$installerType = 'EXE' 
$url = (Join-Path (Join-Path $source "$packageName.12.0.21005.1") "$deploymentFile") # download url
$url64 = $url # 64bit URL uses the same as $url
$silentArgs = "/Quiet /NoRestart /AdminFile $adminFile /Log $env:temp\vs2013.log"
$validExitCodes = @(0,3010) 

try
{
	$isInstalled = Stop-OnAppIsInstalled $packageName $windowsInstallerName
	if($isInstalled -eq $false) {
		Get-ChocolateyWebFile $packageName $copyInstallerToPath $url
		$driveLetter = Mount-Iso -isopath $copyInstallerToPath
		$exeToRun = (Join-Path $driveLetter "vs_ultimate.exe")
		# installer, will assert administrative rights
		Start-ChocolateyProcessAsAdmin -statements $silentArgs -exeToRun "$exeToRun" -validExitCodes $validExitCodes
		Write-ChocolateySuccess $packageName
	}
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
   