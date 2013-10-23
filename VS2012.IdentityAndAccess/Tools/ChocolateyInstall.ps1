$packageName = 'VS2012.IdentityAndAccess'
$windowsInstallerName = 'Identity and Access Tool for Visual Studio 2012.*'
$installerType = 'VSIX' 
$url = 'http://visualstudiogallery.msdn.microsoft.com/e21bf653-dfe1-4d81-b3d3-795cb104066e/file/68485/4/Identity%20and%20Access%20Tool.vsix' # download url
$url64 = $url # 64bit URL uses the same as $url
$silentArgs = "/Quiet /NoRestart /Log VS2012_U2.log"
$validExitCodes = @(0,3010) 
try {
		Install-ChocolateyVsixPackage $packageName $url
}catch {
  Write-ChocolateyFailure $packageName $($_.Exception.Message)
  throw
}
