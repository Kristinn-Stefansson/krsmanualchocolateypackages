$packageName = 'VS2010.SSDT11'
$version = "11.1.31009.1"
$windowsInstallerName = 'Microsoft SQL Server Data Tools 2010'
$installerType = 'EXE' 
$url = 'http://go.microsoft.com/fwlink/?LinkID=320744&clcid=0x409' # download url
$url64 = $url # 64bit URL uses the same as $url
$silentArgs = "/q /norestart /Log $packageName.log"
$validExitCodes = @(0,3010) 
try {
	# installer, will assert administrative rights
	$isInstalled = Stop-OnAppIsInstalled -pkgName $packageName -match $windowsInstallerName -version version
	if($isInstalled -eq $false) {
		Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes
	}
} catch {
  Write-ChocolateyFailure $packageName $($_.Exception.Message)
  throw
}
