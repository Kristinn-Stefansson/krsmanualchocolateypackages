$adminFile = (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'AdminDeployment.xml')

$packageName = 'Expression.Studio4'
$windowsInstallerName = 'Microsoft Expression Studio 4'
$installerType = 'ZIP' 
$url = 'http://download.microsoft.com/download/8/4/9/849ACFED-6607-4758-BAA8-CAB09550EEEE/ExpressionStudio_UltimateTrial_en.exe' # download url
$url64 = $url # 64bit URL uses the same as $url
$silentArgs = "/Quiet /NoRestart /AdminFile $adminFile /Log $env:temp\vs2012.log"
$validExitCodes = @(0) 

try
{
	$isInstalled = Stop-OnAppIsInstalled $packageName $windowsInstallerName
	if($isInstalled -eq $false) {
		# installer, will assert administrative rights
		Start-ChocolateyProcessAsAdmin -statements '/q /norestart /ChainingPackage "ADMINDEPLOYMENT"' -exeToRun "C:\Disks\DownloadedMSDN\VS2012\Microsoft Visual Studio 2012 Ultimate\en_visual_studio_ultimate_2012_x86_dvd_920947\packages\dotNetFramework\dotNetFx45_Full_x86_x64.exe" -validExitCodes $validExitCodes
		Start-ChocolateyProcessAsAdmin -statements $silentArgs -exeToRun "$url" -validExitCodes $validExitCodes
		Write-ChocolateySuccess $packageName
	}
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
   