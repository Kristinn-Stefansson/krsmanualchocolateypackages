$currFolder = $(Split-Path -parent $MyInvocation.MyCommand.Definition)

# Base setings
$packageName = 'SqlServer2008R2'
$version = "10.50.1600.1"
$windowsInstallerName = 'Microsoft SQL Server 2008 R2'
$installerType = 'EXE' 
$user = "SqlServiceRunner"
$password = "r1#Xt$dhI2R&X8%g"
$adminFile = (Join-Path $currFolder 'ConfigurationFile.ini')
$silentArgs = "/SQLSVCPASSWORD=`"$password`" /SAPWD=`"$password`" /ISSVCPASSWORD=`"$password`" /AGTSVCPASSWORD=`"$password`" /ConfigurationFile=`"$adminFile`"" # 
$validExitCodes = @(0,3010) 

# Cached image
$imageFile = "en_sql_server_2008_r2_developer_x86_x64_ia64_dvd_522665.iso"
$image = (Join-Path (Join-Path $source "$packageName.$version") "$imageFile")
$copyInstallerToPath = "$env:TEMP\chocolatey\$packageName\$version\$imageFile"
$imageSetup = ""

Write-Host "Creating a local SqlServiceRunner account."
$previous = [ADSI]"WinNT://$env:COMPUTERNAME/$user"
if($previous.distinquishedName -eq $null)
{
	$objOu = [ADSI]"WinNT://$env:COMPUTERNAME"    
	$objUser = $objOU.Create("User", $user)    
	$objUser.setpassword($password)    
	$objUser.SetInfo()    
	$objUser.description = "Sql Service Runner"
	$objUser.Put("PasswordExpired", 0) 
	$objUser.SetInfo()
	$objUser.Put("UserFlags", 0x10000)
	$objUser.SetInfo()
	[ADSI]$group="WinNT://$env:COMPUTERNAME/Users,Group"
	$group.Add($objUser.path)
}
else
{
	$previous.setpassword($password) 
	$previous.SetInfo()
	$previous.Put("PasswordExpired", 0) 
	$previous.SetInfo()
	$previous.Put("UserFlags", 0x10000)        
	$previous.SetInfo()
	Write-Host "User $user already exists, the password was reset to $password."
}

$isInstalled = Stop-OnAppIsInstalled $packageName $windowsInstallerName
if($isInstalled -eq $false) {
	if(Test-Path $image)
	{
		New-Item -ItemType Directory -Force -Path $(Split-Path -parent $copyInstallerToPath)
		Get-ChocolateyWebFile $packageName $copyInstallerToPath $image
		# installer, will assert administrative rights
		Start-ChocolateyProcessAsAdmin -statements $silentArgs -exeToRun "$copyInstallerToPath" -validExitCodes $validExitCodes
		# $setupProcess = (Get-Process | Where-Object { $_.ProcessName -ieq "Setup" }) 
		# if( $setupProcess -ne $NULL)
		# {
			# Write-Host "Waiting for Sql Server install to finish. If an exit dialog pops up, you will need to close it to finish."
			# $setupProcess.WaitForExit() 
		# }
	}
	else
	{
		Write-ChocolateyFailure -packageName "$packageName" -failureMessage "Unable to find setup image $image"
	}
}