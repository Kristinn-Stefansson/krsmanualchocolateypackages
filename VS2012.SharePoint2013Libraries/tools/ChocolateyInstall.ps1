$packageName = 'VS2012.SharePoint2013Libraries'
$version = "15.0.4535.1000"

$currFolder = $(Split-Path -parent $MyInvocation.MyCommand.Definition)


try {
	Start-ChocolateyProcessAsAdmin -statements "$currFolder\TfsBuildServerPrerequisites.ps1 -Install"
} catch {
  Write-ChocolateyFailure $packageName $($_.Exception.Message)
  throw
}
