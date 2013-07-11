$packageName = 'VS2012.CRMToolKit'
$installerType = 'EXE' 
$url = 'http://download.microsoft.com/download/2/0/4/2041D411-A5DC-48EC-A904-3BB1EE5698A0/MicrosoftDynamicsCRM2011SDK.exe' # download url
$url64 = $url # 64bit URL uses the same as $url
$silentArgs = '/ACTION=INSTALL /Q' # 
$validExitCodes = @(0,3010) 

# installer, will assert administrative rights
# Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes

try { 
        $scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
        $nodePath = Join-Path $scriptPath '\developertoolkit.zip'
        $unzipPath = Join-Path $scriptPath '\toolkit'
        Get-ChocolateyWebFile "$packageName" "$nodePath" "$url" "$url64"
		Get-ChocolateyUnzip "$nodePath" $destination
     
  Write-ChocolateySuccess "$packageName"
} catch {
  Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
  throw 
}