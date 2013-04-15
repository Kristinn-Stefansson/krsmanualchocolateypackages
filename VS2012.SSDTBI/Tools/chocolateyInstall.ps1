$packageName = 'VS2012.SSDTBI'
$installerType = 'EXE' 
$url = 'http://download.microsoft.com/download/5/C/4/5C4AFD6F-C26F-4E3A-8BE9-8AC43F9039E3/SSDTBI_VS2012_x86_ENU.exe' # download url
$url64 = $url # 64bit URL uses the same as $url
$silentArgs = '/ACTION=INSTALL /FEATURES=SSDTBI_VS2012 /Q /IACCEPTSQLSERVERLICENSETERMS' # 
$validExitCodes = @(0) 

# installer, will assert administrative rights
Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes