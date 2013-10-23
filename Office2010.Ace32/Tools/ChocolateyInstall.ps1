# #if(-not (test-path "hklm:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319\SKUs\.NETFramework,Version=v4.5")) {
# Install-ChocolateyPackage `
	# 'MSAccess210-redist' 'exe' "/Passive /NoRestart /Log:$($env:temp)\MSAccess210-redist.log" `
	# 'http://download.microsoft.com/download/2/4/3/24375141-E08D-4803-AB0E-10F2E3A07AAA/AccessDatabaseEngine.exe' `
	# 'http://download.microsoft.com/download/2/4/3/24375141-E08D-4803-AB0E-10F2E3A07AAA/AccessDatabaseEngine_x64.exe'
# #}
# #else {
# #     Write-Host "Microsoft Access 2010 Redistributable is already installed on your machine."
# # } 
$packageName = 'Office2010.Ace32'
$installerType = 'EXE' 
$url = 'http://download.microsoft.com/download/2/4/3/24375141-E08D-4803-AB0E-10F2E3A07AAA/AccessDatabaseEngine.exe' # download url
$url64 = 'http://download.microsoft.com/download/2/4/3/24375141-E08D-4803-AB0E-10F2E3A07AAA/AccessDatabaseEngine_x64.exe' # 64bit URL is not used here
$silentArgs = '/quiet /norestart' # 
$validExitCodes = @(0,3010) 

# installer, will assert administrative rights
Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" -validExitCodes $validExitCodes