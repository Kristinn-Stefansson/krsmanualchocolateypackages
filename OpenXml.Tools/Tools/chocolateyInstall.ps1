$packageName = 'OpenXml.Tools'
$installerType = 'MSI' 
$url = 'http://download.microsoft.com/download/5/5/3/553C731E-9333-40FB-ADE3-E02DC9643B31/OpenXMLSDKToolV25.msi' # download url
$url64 = $url # 64bit URL uses the same as $url
$silentArgs = '/quiet /norestart' # 
$validExitCodes = @(0,3010) 

# installer, will assert administrative rights
Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes