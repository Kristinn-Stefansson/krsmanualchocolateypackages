$packageName = 'VS2012.SSDT11'
$version = "11.1.21208.0"
$windowsInstallerName = 'Microsoft SQL Server Data Tools 2012'
$installerType = 'EXE' 
$url = 'http://go.microsoft.com/fwlink/?LinkID=274984' # download url
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
