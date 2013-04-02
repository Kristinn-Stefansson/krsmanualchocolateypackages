Import-Module $env:appdata\boxstarter\Boxstarter.Chocolatey\Boxstarter.Chocolatey.psd1
#Create minimal nuspec and chocolateyInstall
New-BoxstarterPackage DevSetup2013
#Edit Install script to customize your environment
Notepad (Join-Path $Boxstarter.LocalRepo "DevSetup2013\tools\ChocolateyInstall.ps1")
#Pack nupkg
Invoke-BoxstarterBuild DevSetup2013

#share Repo
# Set-BoxstarterShare
#Or Copy to thumb drive G
# Copy-Item $Boxstarter.BaseDir G:\ -Recurse

#on new bare os
# \\MYCOMPUTER\Boxstarter\Boxstarter DevSetup2013
 
#Enter password when prompted and come back later to new box