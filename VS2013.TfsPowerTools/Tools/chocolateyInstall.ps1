$packageName = 'VS2013.TfsPowertools'
$installerType = 'MSI' 
$url = 'http://visualstudiogallery.msdn.microsoft.com/f017b10c-02b4-4d6d-9845-58a06545627f/file/112253/2/Visual%20Studio%20Team%20Foundation%20Server%202013%20Power%20Tools.msi' # download url
$url64 = $url # 64bit URL uses the same as $url
$silentArgs = "/Quiet /NoRestart /Log $env:temp\Windows8.SDK.log"
$validExitCodes = @(0,3010) 

# installer, will assert administrative rights
Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" -validExitCodes $validExitCodes
   
