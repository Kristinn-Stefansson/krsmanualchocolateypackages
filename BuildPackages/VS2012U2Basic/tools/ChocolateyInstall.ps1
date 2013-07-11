try {
Update-ExecutionPolicy Unrestricted
cinstm pswindowsupdate # Alternative version of windows updater PS interface
Import-Module PsWindowsUpdate
# Install-WindowsUpdate -AcceptEula
if(Get-WURebootStatus -Silent){Invoke-Reboot}
cinstm -source \\fisnets2\systems$\tfs\pub\SharedFunctionality\SharedBinaries\Chocolatey developer.setup.extension
cinstm -source \\fisnets2\systems$\tfs\pub\SharedFunctionality\SharedBinaries\Chocolatey VS2012.Ultimate
cinstm -source \\fisnets2\systems$\tfs\pub\SharedFunctionality\SharedBinaries\Chocolatey VS2012.Update1
cwebpi DACFX
cinstm tfs2012powertools
cwebpi SSDTVS2010
cwebpi SSDTVS2012
cinstm -source \\fisnets2\systems$\tfs\pub\SharedFunctionality\SharedBinaries\Chocolatey VS2012.SSDTBI 
cinstm -source \\fisnets2\systems$\tfs\pub\SharedFunctionality\SharedBinaries\Chocolatey VS2012.Update2
Get-WUInstall -AcceptAll -IgnoreRebootRequired
if(Get-WURebootStatus -Silent){Invoke-Reboot}
    Write-ChocolateySuccess 'DevSetup2013'
} catch {
  Write-ChocolateyFailure 'DevSetup2013' $($_.Exception.Message)
  throw
}