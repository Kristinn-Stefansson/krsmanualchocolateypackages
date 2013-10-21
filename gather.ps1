
cd .\VS2013.Ultimate
cpack
cd ..\VS2012.SSDTBI
cpack
cd ..\VS2012.ToolsForGit
cpack
cd ..\VS2012.Ultimate
cpack
cd ..\VS2012.Pro
cpack
cd ..\VS2012.Update3
cpack
cd ..\MSDN.NET451
cpack
cd ..\VS2012.NET45
cpack
cd ..\VS2012.Update1
cpack
cd ..\VS2012.Update2
cpack
cd ..\VS2012.Update
cpack
cd ..\VS2012.SSDT11
cpack
cd ..\VS2010.SSDT10
cpack
cd ..\OpenXml.SDK
cpack
cd ..\BonjourPrintServices
cpack
cd ..\beyondcompare
cpack
cd ..\OpenXml.Tools
cpack
cd ..\SqlServer2008R2
cpack
cd ..\SqlServer2008R2.DTS
cpack
cd ..\SqlServer2008R2SP2
cpack
cd ..\developer.setup.extension 
cpack
cd ..\BuildPackages\VS2012U2Basic
cpack
cd ..\..\

$g = Get-ChildItem -Recurse -Include *.nupkg 
$g | % {
	if((Test-Path C:\Users\Kristinn\SkyDrive\Code\Chocolatey -pathType container))
	{	
		Copy-Item $_.FullName -destination C:\Users\Kristinn\SkyDrive\Code\Chocolatey -Force
	}
	if((Test-Path C:\NoBackup\SkyDrive\Code\Chocolatey -pathType container))
	{	
		Copy-Item $_.FullName -destination C:\NoBackup\SkyDrive\Code\Chocolatey -Force
	}
	if((Test-Path C:\NoBackup\ChocolateyGallery\Internal -pathType container))
	{	
		Copy-Item $_.FullName -destination C:\NoBackup\ChocolateyGallery\Internal -Force
	}
}
 $g | % {
	 if((Test-Path \\fisnets2\systems$\TFS\Pub\SharedFunctionality\SharedBinaries\Chocolatey -pathType container))
	{
		Move-Item $_.FullName -destination \\fisnets2\systems$\TFS\Pub\SharedFunctionality\SharedBinaries\Chocolatey -Force
	}
}