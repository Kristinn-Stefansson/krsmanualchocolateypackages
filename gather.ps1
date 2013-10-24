$gatherRootFolder = $(Split-Path -parent $MyInvocation.MyCommand.Definition)

Write-Host "Starting check in $gatherRootFolder"

foreach($folder in (Get-ChildItem $gatherRootFolder | where {$_.Attributes -like '*Directory*'} ))
{
    Write-Host "Checking in $gatherRootFolder\$folder\"
    $nuspec = @(Get-ChildItem "$gatherRootFolder\$folder\*.nuspec")
    if($nuspec -ne $null -and $nuspec.Count -ge 0)
    {
        Write-Host "Found $nuspec"
        $compile = $true
        $nuget = @(Get-ChildItem "$gatherRootFolder\$folder\*.nupkg" | Where-Object {$_.BaseName -match "$($nuspec[0].BaseName)\..*"} )
        if($nuget -ne $null)
        {
            if($nuget.Count -eq 1)
            {
                Write-Host "Found $nuget[0] : $($nuspec[0].LastWriteTime) < $($nuget[0].LastWriteTime)" 
                if($nuspec[0].LastWriteTime -le $nuget[0].LastWriteTime)
                {
                    $compile = $false
                    Write-Host "No need to compile $name" -ForegroundColor Green
                }
                else
                {
                    Write-Host "Removing old items: $nuget" -ForegroundColor Magenta
                    Del $nuget
                }
            }
            elseif($nuget.Count -gt 1)
            {
                Write-Host "Removing multiple items: $nuget" -ForegroundColor Magenta
                Del $nuget
            }
        }
        if($compile)
        {
            Write-Host "Start compile $name" -ForegroundColor Yellow
            
            cd  "$gatherRootFolder\$folder"
            cpack "$($nuspec[0].FullName)" 
            cd ..
        }
    }
}


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
		Copy-Item $_.FullName -destination \\fisnets2\systems$\TFS\Pub\SharedFunctionality\SharedBinaries\Chocolatey -Force
	}
}