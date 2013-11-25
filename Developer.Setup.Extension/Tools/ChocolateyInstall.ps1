
$packageName = 'developer.setup.extension'
$currentDir = (Split-Path -parent $MyInvocation.MyCommand.Definition)
$include = Join-Path $currentDir "HelperFunctions.ps1"
."$include"

$rootDrive = $env:SystemDrive
$diskFolder = "$rootDrive\Disks"
# $sharedBineriesLink = Join-Path $diskFolder "SharedBinaries"
# $downloadedFiles = Join-Path $diskFolder "DownloadedMSDN"
# $chocoCache = Join-Path $sharedBineriesLink "ExternalCache"

# Create-Folder -folderPath $diskFolder
# Create-Folder -folderPath $downloadedFiles
	# New-SymbolicLink -link "$sharedBineriesLink" -target "\\fisnets2\systems$\TFS\Pub\SharedFunctionality\SharedBinaries" -force
	if([Environment]::GetEnvironmentVariable("CHOCOLATEY_CACHE", "Machine") -eq $NULL)
	{
		Install-ChocolateyEnvironmentVariable "CHOCOLATEY_CACHE" "$chocoCache" Machine
	}
	 
	# if (Get-Command "Mount-DiskImage" -errorAction SilentlyContinue)
	# {
		# # Running on Windows 6.3 with powershell
	# }
	# elseif($source -ne $NULL)
	# {
		# # Need to ensure Arion.VirtualCloneDrive is installed, preferably from the same source
		# choco install Arion.VirtualCloneDrive -source $source
	# }
	# else
	# {
		# # Need to ensure Arion.VirtualCloneDrive is installed
		# choco install Arion.VirtualCloneDrive
	# }
	# New-SymbolicLink -link (Join-Path $downloadedFiles "VS2010") -target "\\fisnets6\Download\Microsoft\Visual_Studio_2010" -force
	# New-SymbolicLink -link (Join-Path $downloadedFiles "VS2012") -target "\\fisnets6\Download\Microsoft\Visual Studio 2012" -force
	# New-SymbolicLink -link (Join-Path $downloadedFiles "SQL2012") -target "\\fisnets6\Download\Microsoft\Microsoft_Sql_Server_2012_Developer_Edition" -force
	# New-SymbolicLink -link (Join-Path $downloadedFiles "SQL2008R2") -target "\\fisnets6\Download\Microsoft\SQL_Server_2008_R2_Developers" -force
	# New-SymbolicLink -link (Join-Path $downloadedFiles "SQL2008R2SP2") -target "\\fisnets6\Download\Microsoft\SQLServer2008R2-SP2" -force
	# New-SymbolicLink -link (Join-Path $downloadedFiles "Office2010") -target "\\fisnets6\Download\Microsoft\Office2010" -force
	# New-SymbolicLink -link (Join-Path $downloadedFiles "Office2013") -target "\\fisnets6\Download\Microsoft\Office 2013\Office Professional Plus 2013 (x86 and x64) - DVD (English)" -force
