$packageName = 'VS2012.TfsPowertools'
$installerType = 'MSI' 
$url = 'http://visualstudiogallery.msdn.microsoft.com/b1ef7eb2-e084-4cb8-9bc7-06c3bad9148f/file/83775/3/Visual%20Studio%20Team%20Foundation%20Server%202012%20Update%202%20Power%20Tools.msi' # download url
$url64 = $url # 64bit URL uses the same as $url
$silentArgs = "/Quiet /NoRestart /Log $env:temp\Windows8.SDK.log"
$validExitCodes = @(0,3010) 

# installer, will assert administrative rights
Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" -validExitCodes $validExitCodes
   
