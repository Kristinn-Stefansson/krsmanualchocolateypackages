$currFolder = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$adminFile = (Join-Path $currFolder 'AdminDeployment.xml')

$deploymentFile = "mu_.net_fx_4_5_1_dp_win_vistasp2_win_7sp1_win_8_win_8_1_win_server_2008sp2_win_server_2008_r2sp1_win_server_2012_win_server_2012r2_x86_x64_3009815.exe"
$copyInstallerToPath = "$env:TEMP\chocolatey\$packageName\$deploymentFile"
$packageName = 'MSDN.NET451'
$windowsInstallerName = 'Microsoft Visual Studio Ultimate 2014'
$installerType = 'EXE' 
$url = (Join-Path (Join-Path $source "$packageName.4.5.50938.18408") "$deploymentFile") # download url
$url64 = $url # 64bit URL uses the same as $url
$silentArgs = "/Quiet /NoRestart /AdminFile $adminFile /Log $env:temp\VS2012NET451.log"
$validExitCodes = @(0,3010) 

try
{
	$isInstalled = Stop-OnAppIsInstalled $packageName $windowsInstallerName
	if($isInstalled -eq $false) {
		Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes
	}
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
   