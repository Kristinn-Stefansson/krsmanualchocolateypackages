try {

Get-WUInstall -AcceptAll -IgnoreRebootRequired
# Install-WindowsUpdate -AcceptEula
Update-ExecutionPolicy Unrestricted
# Move-LibraryDirectory "Personal" "$env:UserProfile\skydrive\documents"
Set-ExplorerOptions -showHidenFilesFoldersDrives -showProtectedOSFiles -showFileExtensions
Set-TaskbarSmall
Enable-RemoteDesktop
cinstm pswindowsupdate # Alternative version of windows updater PS interface
Import-Module PsWindowsUpdate
if(Get-WURebootStatus -Silent){Invoke-Reboot}
cinstm VisualStudio2012Ultimate
if((Get-Item "$($Boxstarter.programFiles86)\Microsoft Visual Studio 11.0\Common7\IDE\devenv.exe").VersionInfo.ProductVersion -lt "11.0.60115.1") {
    if(Get-WURebootStatus -Silent){Invoke-Reboot}
    Install-ChocolateyPackage 'vs update 2 ctp2' 'exe' '/passive /norestart' 'http://download.microsoft.com/download/8/9/3/89372D24-6707-4587-A7F0-10A29EECA317/vsupdate_KB2707250.exe'
}
Import-Module PsWindowsUpdate
Get-WUInstall -AcceptAll -IgnoreRebootRequired
if(Get-WURebootStatus -Silent){Invoke-Reboot}
cinstm fiddler
cinstm mssqlserver2012express
cinstm git-credential-winstore # For storing credentials GIT repositories
cinstm console-devel # This is a development branch of Console by Marko Bozikovic
cinstm sublimetext2 # Sublime Text 2 is a sophisticated text editor for code, html and prose.
cinstm skydrive
cinstm poshgit #posh-git - A set of PowerShell scripts which provide Git/PowerShell integration
cinstm dotpeek # dotPeek is a new free .NET decompiler from JetBrains, the makers of ReSharper
cinstm googlechrome
cinstm Paint.net
cinstm windirstat
cinstm notepadplusplus
cinstm sysinternals # Install common systernal troubleshooting tools
cinstm NugetPackageExplorer
cinstm resharper
# cinstm ghostdoc # Needs update? At least not working.
# cinstm windbg # Microsoft Windows Debugger, seemed not to work (1.4.2012)
cinstm tfs2012powertools
# Need Specflow
cinstm webpicommandline
# Various tools from webpi
cwebpi IIS7                 		#IIS Recommended Configuration
cwebpi IISExpress_ByPlatform 		#IIS 8.0 Express (Windows Vista and up) Or IIS 7.5 Express (Windows XP)- August 2012
cwebpi SQLLocalDB           		#Microsoft SQL Express LocalDB Edition 11.0
cwebpi WIFSDK               		#Windows Identity Foundation SDK
cwebpi WindowsInstaller45   		#Windows Installer 4.5
cwebpi ASPDOTNETandWebTools2012_2 	#ASP.NET and Web Tools 2012.2
cwebpi DACFX                		#Microsoft SQL Server 2012 Data-Tier Application Framework (DACFx) (March 2013)
cwebpi OfficeToolsForVS2012RTW		#Microsoft Office Developer Tools for Visual Studio 2012
cwebpi ServiceBusCU1        		#Service Bus 1.0 Cumulative Update 1
cwebpi SSDTVS2010           		#Microsoft SQL Server Data Tools for Visual Studio 2010
cwebpi SSDTVS2012           		#Microsoft SQL Server Data Tools for Visual Studio 2012
cwebpi VS2012LS2NOSQL       		#LightSwitch in Visual Studio 2012 - Server Configuration without local SQL Express
cwebpi WorkflowClient       		#Workflow Client 1.0
# cwebpi AppFabric            		#Windows Server AppFabric
# cwebpi SQLManagementStudio  		#SQL Server 2008 R2 Management Studio Express with SP1
# cwebpi WDeployPS            		#Web Deploy 3.0 for Hosting Servers
# cwebpi Silverlight5Tools    		#Silverlight 5 Tools for Visual Studio 2010
# cwebpi MVC2                 		#ASP.NET MVC 2
# cwebpi MVC3                 		#ASP.NET MVC 3 (Visual Studio 2010)
# cwebpi netframework2        		#.NET Framework 2.0 SP 2
# cwebpi NETFramework35       		#.NET Framework 3.5 SP 1
# cwebpi NETFramework45       		#Microsoft .NET Framework 4.5
# cwebpi NETFramework4PU3     		#Microsoft .NET Framework 4 - Runtime Update 3
# cwebpi Silverlight4Toolkit  		#Silverlight 4 Toolkit April 2010 Release
# cwebpi SMO_11_0             		#SQL Server 2012 Shared Management Objects (April 2012)
# cwebpi SQLCE                		#Microsoftr SQL Serverr Compact Latest
# cwebpi SQLCE_4_0            		#Microsoftr SQL Serverr Compact 4.0 SP1
# cwebpi SQLCEforWM           		#Microsoftr SQL Serverr Compact 4.0 SP1 CTP1
# cwebpi SQLCEVSTools_4_0     		#Microsoft Visual Studio 2010 SP1 Tools for SQL Server Compact 4.0
# cwebpi ExpressionEncoder4   		#Expression Encoder 4 with Service Pack 2
# cwebpi ExpressionWeb        		#Expression Web 4 Trial

# cinst Microsoft-Hyper-V-All -source windowsFeatures
# cinst IIS-WebServerRole -source windowsfeatures
# cinst IIS-HttpCompressionDynamic -source windowsfeatures
# cinst IIS-ManagementScriptingTools -source windowsfeatures
# cinst IIS-WindowsAuthentication -source windowsfeatures
cinst TelnetClient -source windowsFeatures

$sublimeDir = "$env:programfiles\Sublime Text 2"

Install-ChocolateyPinnedTaskBarItem "$env:windir\system32\mstsc.exe"
Install-ChocolateyPinnedTaskBarItem "$env:programfiles\console\console.exe"
Install-ChocolateyPinnedTaskBarItem "$sublimeDir\sublime_text.exe"
Install-ChocolateyPinnedTaskBarItem "$($Boxstarter.programFiles86)\Google\Chrome\Application\chrome.exe"
Install-ChocolateyPinnedTaskBarItem "$($Boxstarter.programFiles86)\Microsoft Visual Studio 11.0\Common7\IDE\devenv.exe"

Install-ChocolateyFileAssociation ".txt" "$env:programfiles\Sublime Text 2\sublime_text.exe"
Install-ChocolateyFileAssociation ".dll" "$($Boxstarter.ChocolateyBin)\dotPeek.bat"

if(!(Test-Path("$sublimeDir\data"))){mkdir "$sublimeDir\data"}
copy-item (Join-Path (Get-PackageRoot($MyInvocation)) 'sublime\*') -Force -Recurse "$sublimeDir\data"
move-item "$sublimeDir\data\Pristine Packages\*" -Force "$sublimeDir\Pristine Packages"
copy-item (Join-Path (Get-PackageRoot($MyInvocation)) 'console.xml') -Force $env:appdata\console\console.xml

Install-ChocolateyVsixPackage identityandaccesstool http://visualstudiogallery.msdn.microsoft.com/e21bf653-dfe1-4d81-b3d3-795cb104066e/file/68485/4/Identity%20and%20Access%20Tool.vsix
Install-ChocolateyVsixPackage sqlite-winrt http://visualstudiogallery.msdn.microsoft.com/23f6c55a-4909-4b1f-80b1-25792b11639e/file/79478/11/sqlite-winrt-3071601.vsix
Install-ChocolateyVsixPackage samplebrowser http://visualstudiogallery.msdn.microsoft.com/4934b087-e6cc-44dd-b992-a71f00a2a6df/file/50587/34/SampleBrowser.vsix
Install-ChocolateyVsixPackage regularexpressiontester http://visualstudiogallery.msdn.microsoft.com/bf883ae3-188b-43bc-bd29-6235c4195d1f/file/53270/7/Regular%20Expression%20Tester%20Extension.vsix
Install-ChocolateyVsixPackage xunit http://visualstudiogallery.msdn.microsoft.com/463c5987-f82b-46c8-a97e-b1cde42b9099/file/66837/1/xunit.runner.visualstudio.vsix
Install-ChocolateyVsixPackage autowrocktestable http://visualstudiogallery.msdn.microsoft.com/ea3a37c9-1c76-4628-803e-b10a109e7943/file/73131/1/AutoWrockTestable.vsix
# Install-ChocolateyVsixPackage vscommands http://visualstudiogallery.msdn.microsoft.com/a83505c6-77b3-44a6-b53b-73d77cba84c8/file/74740/18/SquaredInfinity.VSCommands.VS11.vsix

cinstm powershell # Ensure WMF 3.0
Import-Module PsWindowsUpdate
Get-WUInstall -AcceptAll -IgnoreRebootRequired
if(Get-WURebootStatus -Silent){Invoke-Reboot}
    Write-ChocolateySuccess 'DevSetup2013'
} catch {
  Write-ChocolateyFailure 'DevSetup2013' $($_.Exception.Message)
  throw
}