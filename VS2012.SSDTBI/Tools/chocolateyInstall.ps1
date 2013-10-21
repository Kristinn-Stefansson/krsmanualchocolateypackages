$currFolder = $(Split-Path -parent $MyInvocation.MyCommand.Definition)

# Base setings
$packageName = 'VS2012.SSDTBI'
$version = "11.0.3369.1"
$windowsInstallerName = 'Microsoft SQL Server Data Tools - Business Intelligence for Visual Studio 2012.*'
$installerType = 'EXE' 
$silentArgs = '/ACTION=INSTALL /FEATURES=SSDTBI_VS2012 /Q /IACCEPTSQLSERVERLICENSETERMS' # 
$validExitCodes = @(0,3010) 

# Cached image
$imageFile = "SSDTBI_VS2012_x86_ENU.exe"
$image = (Join-Path (Join-Path $source "$packageName.$version") "$imageFile")
$copyInstallerToPath = "$env:TEMP\chocolatey\$packageName\$version\$imageFile"

# Download URL
$url = 'http://download.microsoft.com/download/5/C/4/5C4AFD6F-C26F-4E3A-8BE9-8AC43F9039E3/SSDTBI_VS2012_x86_ENU.exe' # download url
$url64 = $url # 64bit URL uses the same as $url

$isInstalled = Stop-OnAppIsInstalled $packageName $windowsInstallerName
if($isInstalled -eq $false) {
	if(Test-Path $image)
	{
		New-Item -ItemType Directory -Force -Path $(Split-Path -parent $copyInstallerToPath)
		Get-ChocolateyWebFile $packageName $copyInstallerToPath $image
		# installer, will assert administrative rights
		Start-ChocolateyProcessAsAdmin -statements $silentArgs -exeToRun "$copyInstallerToPath" -validExitCodes $validExitCodes
	}
	else
	{
		# installer, will assert administrative rights
		Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes
	}
}