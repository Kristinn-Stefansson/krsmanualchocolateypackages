$currFolder = $(Split-Path -parent $MyInvocation.MyCommand.Definition)

# Base setings
$packageName = 'SqlServer2008R2SP2'
$version = "10.50.4000.0"
$installerType = 'EXE' 
$adminFile = (Join-Path $currFolder 'ConfigurationFile.ini')
$silentArgs = '/ConfigurationFile=$adminFile' # 
$validExitCodes = @(0,3010) 

# Cached image
$imageFile = "SQLServer2008R2SP2-KB2630458-x64-ENU.exe"
$image = (Join-Path (Join-Path $source "$packageName.$version") "$imageFile")
$copyInstallerToPath = "$env:TEMP\chocolatey\$packageName\$version\$imageFile"

# Download URL
$url = 'http://download.microsoft.com/download/3/D/C/3DC6663D-8A76-40A6-BCF2-2808C385D56A/SQLServer2008R2SP2-KB2630458-x86-ENU.exe' # download url
$url64 = "http://download.microsoft.com/download/3/D/C/3DC6663D-8A76-40A6-BCF2-2808C385D56A/SQLServer2008R2SP2-KB2630458-x64-ENU.exe" # 64bit URL uses the same as $url

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


