$packageName = 'Windows8.SDK'
$windowsInstallerName = 'Windows Software Development Kit for Windows 8.1'
$installerType = 'EXE' 
$url = 'http://download.microsoft.com/download/E/5/D/E5DEED97-B850-4F9A-B660-4AAABE55A931/standalonesdk/sdksetup.exe' # download url
$url64 = $url # 64bit URL uses the same as $url
$silentArgs = "/Quiet /NoRestart /Log $env:temp\Windows8.SDK.log"
$validExitCodes = @(0,3010) 

# installer, will assert administrative rights
Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" -validExitCodes $validExitCodes
   