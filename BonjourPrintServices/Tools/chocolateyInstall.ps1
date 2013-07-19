$packageName = 'BonjourPrintServices'
$installerType = 'EXE' 
$url = 'http://support.apple.com/downloads/DL999/en_US/BonjourPSSetup.exe' # download url
$url64 = $url # 64bit URL uses the same as $url
$silentArgs = '/quiet /norestart' # 
$validExitCodes = @(0,3010) 

# installer, will assert administrative rights
Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes