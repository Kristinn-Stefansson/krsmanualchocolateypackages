# Creates a Vista symbolic link by calling cmd.exe mklink
function New-SymbolicLink(
    [string] $link = $(throw 'Must supply a link path'),
    [string] $target = $(throw 'Must supply a target path'),
    [switch] $force
) {
    if (Test-Path $link)
    {
        if ($force) { 
            Write-Host "Remove previous link: $link"
            cmd /c rmdir $link 
        } else {
            throw "Link path already exists: $link"
        }
    }
    if (-not (test-path $target)) { throw "Target does not exist: $target" }

    # If the target is a directory make a directory symlink. Otherwise make a file link
    $d = ""
    if (test-path $target -type Container) { $d = '/d' }

    if ([Environment]::OSVersion.Version.Major -ge 6)
    {
        cmd /c "mklink $d `"$link`" `"$target`"" > $null
    }
    else
    {
        cmd /c "junction $d `"$link`" `"$target`"" > $null
    }
}

#Create a new folder if none found
function Create-Folder(
    [string] $folderPath = $(throw 'Must supply a folder path')
)
{

    if((Test-Path $folderPath) -eq $FALSE)
    {
        Write-Host "Creating the $folderPath directory."
        New-Item -ItemType directory -Path $folderPath
    }
    else
    {
        Write-Host "Found $folderPath directory."
    }
}