
cd .\VS2012.Ultimate
cpack
cd ..\VS2012.NET45
cpack
cd ..\VS2012.Update1
cpack
cd ..\VS2012.Update2
cpack
cd ..\VS2012.Update
cpack
cd ..\VS2012.SSDTBI
cpack
cd ..\VS2012.SSDT11
cpack
cd ..\VS2010.SSDT10
cpack
cd ..\OpenXml.SDK
cpack
cd ..\OpenXml.Tools
cpack
cd ..\SqlServer2008R2.DTS
cpack
cd ..\developer.setup.extension 
cpack
cd ..\BuildPackages\VS2012U2Basic
cpack
cd ..\..\

$g = Get-ChildItem -Recurse -Include *.nupkg 
$g | % {
    Copy-Item $_.FullName -destination C:\NoBackup\SkyDrive\Code\Chocolatey -Force
}
 $g | % {
    Move-Item $_.FullName -destination \\fisnets2\systems$\TFS\Pub\SharedFunctionality\SharedBinaries\Chocolatey -Force
}