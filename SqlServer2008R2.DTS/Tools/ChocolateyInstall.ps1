try
{
    $adminFile = (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'ConfigurationFile.ini')

	# Microsoft SQL Server 2005 Backward Compatibility Components
    Install-ChocolateyPackage 'SqlServer2008R2.DTS.SS2005BC' 'msi' "/quiet" 'http://download.microsoft.com/download/4/4/D/44DBDE61-B385-4FC2-A67D-48053B8F9FAD/SQLServer2005_BC.msi' 'http://download.microsoft.com/download/4/4/D/44DBDE61-B385-4FC2-A67D-48053B8F9FAD/SQLServer2005_BC_x64.msi'
	Install-ChocolateyPackage 'SqlServer2008R2.DTS.SS2000DC' 'msi' "/quiet" 'http://download.microsoft.com/download/4/4/D/44DBDE61-B385-4FC2-A67D-48053B8F9FAD/SQLServer2005_DTS.msi'
	
	Copy-Item -Path "${env:ProgramFiles(x86)}\Microsoft SQL Server\80\Tools\Binn\SEMSFC.DLL" -Destination "${env:ProgramFiles(x86)}\Microsoft SQL Server\100\Tools\Binn\VSShell\Common7\IDE\"
	Copy-Item -Path "${env:ProgramFiles(x86)}\Microsoft SQL Server\80\Tools\Binn\SQLGUI.DLL" -Destination "${env:ProgramFiles(x86)}\Microsoft SQL Server\100\Tools\Binn\VSShell\Common7\IDE\"
	Copy-Item -Path "${env:ProgramFiles(x86)}\Microsoft SQL Server\80\Tools\Binn\SQLSVC.DLL" -Destination "${env:ProgramFiles(x86)}\Microsoft SQL Server\100\Tools\Binn\VSShell\Common7\IDE\"

	Copy-Item -Path "${env:ProgramFiles(x86)}\Microsoft SQL Server\80\Tools\Binn\Resources\1033\SEMSFC.RLL" -Destination "${env:ProgramFiles(x86)}\Microsoft SQL Server\100\Tools\Binn\VSShell\Common7\IDE\Resources\1033\"
	Copy-Item -Path "${env:ProgramFiles(x86)}\Microsoft SQL Server\80\Tools\Binn\Resources\1033\SQLGUI.RLL" -Destination "${env:ProgramFiles(x86)}\Microsoft SQL Server\100\Tools\Binn\VSShell\Common7\IDE\Resources\1033\"
	Copy-Item -Path "${env:ProgramFiles(x86)}\Microsoft SQL Server\80\Tools\Binn\Resources\1033\SQLSVC.RLL" -Destination "${env:ProgramFiles(x86)}\Microsoft SQL Server\100\Tools\Binn\VSShell\Common7\IDE\Resources\1033\"

	Copy-Item -Path "${env:ProgramFiles(x86)}\Microsoft SQL Server\80\Tools\Binn\SEMSFC.DLL" -Destination "${env:ProgramFiles(x86)}\Microsoft Visual Studio 9.0\Common7\IDE\"
	Copy-Item -Path "${env:ProgramFiles(x86)}\Microsoft SQL Server\80\Tools\Binn\SQLGUI.DLL" -Destination "${env:ProgramFiles(x86)}\Microsoft Visual Studio 9.0\Common7\IDE\"
	Copy-Item -Path "${env:ProgramFiles(x86)}\Microsoft SQL Server\80\Tools\Binn\SQLSVC.DLL" -Destination "${env:ProgramFiles(x86)}\Microsoft Visual Studio 9.0\Common7\IDE\"

	$destinationFolder = "${env:ProgramFiles(x86)}\Microsoft Visual Studio 9.0\Common7\IDE\Resources\1033\"
	if (!(Test-Path -path $destinationFolder)) {New-Item $destinationFolder -Type Directory}
	Copy-Item -Path "${env:ProgramFiles(x86)}\Microsoft SQL Server\80\Tools\Binn\Resources\1033\SEMSFC.RLL" -Destination "$destinationFolder" -force
	Copy-Item -Path "${env:ProgramFiles(x86)}\Microsoft SQL Server\80\Tools\Binn\Resources\1033\SQLGUI.RLL" -Destination "$destinationFolder" -force
	Copy-Item -Path "${env:ProgramFiles(x86)}\Microsoft SQL Server\80\Tools\Binn\Resources\1033\SQLSVC.RLL" -Destination "$destinationFolder" -force

    Write-ChocolateySuccess 'SqlServer2008R2.DTS'
} catch {
    Write-ChocolateyFailure 'SqlServer2008R2.DTS' $($_.Exception.Message)
    throw
}