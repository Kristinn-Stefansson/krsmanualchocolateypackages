#requires -version 2.0
#
# Based on https://gist.github.com/MarkRobertJohnson/5893554
#
Add-Type @"
public class Shift {
   public static int   Right(int x,   int count) { return x >> count; }
   public static uint  Right(uint x,  int count) { return x >> count; }
   public static long  Right(long x,  int count) { return x >> count; }
   public static ulong Right(ulong x, int count) { return x >> count; }
   public static int    Left(int x,   int count) { return x << count; }
   public static uint   Left(uint x,  int count) { return x << count; }
   public static long   Left(long x,  int count) { return x << count; }
   public static ulong  Left(ulong x, int count) { return x << count; }
}                    
"@
 
function Open-MountedIso ([string]$isoPath)
{
  <#
		.SYNOPSIS
			Mounts the specified ISO file
	
		.DESCRIPTION
			Mounts the specified image file and returns the drive letter that was mounted
	
		.PARAMETER  isoPath
			the Path of the image file
	
		.EXAMPLE
			PS C:\> $mountedDrive = Open-MountedIso "c:\Stuff.iso"
	
		.INPUTS
			System.String
	
		.OUTPUTS
			The drive letter
	
		.NOTES
			Requires Virtual Clone Drive and at least one drive letter is configured in Virtual Clone Drive
 
	#>
	if (Get-Command "Mount-DiskImage" -errorAction SilentlyContinue)
	{
		Mount-DiskImage -ImagePath $isoPath
        $ret = (Get-DiskImage -ImagePath $isoPath | Get-Volume).DriveLetter + ":\"
	}
	else
	{
		$vcd = Get-VCDMountIso -isoPath $isoPath -waitUntilDriveAvailable $false
        $ret = $vcd.Root
	}
    return $ret
}

function Close-MountedIso ([string]$driveLetter)
{
    try
    {
        $sa = New-Object -comObject Shell.Application
        $sa.Namespace(17).ParseName($driveLetter).InvokeVerb("Eject")
    }
    catch
    {
    }
}
 
 
function Get-VCDMountIso([string]$isoPath, [switch]$waitUntilDriveAvailable) {
  <#
		.SYNOPSIS
			Uses Virtual Clone Drive to mount the specified ISO file
	
		.DESCRIPTION
			Mounts the specified image file and returns the PSDrive that was mounted
	
		.PARAMETER  isoPath
			the Path of the image file
	
		.EXAMPLE
			PS C:\> $mountedDrive = Get-VCDMountIso "c:\Stuff.iso"
	
		.INPUTS
			System.String
	
		.OUTPUTS
			PSDrive
	
		.NOTES
			Requires Virtual Clone Drive and at least one drive letter is configured in Virtual Clone Drive
 
	#>
	
	
	$vcdPath = ""
 
	$path = (gi "Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\VCDMount.exe" -errorAction silentlycontinue)
	if($path) {
	$vcdPath = $path.GetValue($null)
	if(-not [io.File]::exists($vcdPath)) {
		throw "The file $vcdPath does not exist, please install Virtual Clone Drive"
	}
	} else {
	throw "The registry key 'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\VCDMount.exe' was not found.  Please install Virtual Clone Drive"
	}
 
	$drives = Get-VCDPSDrives
	$driveToMount = $null
	if(-not $drives) { throw "Virtual Clone Drive does not have any drive letters assigned.  Please assign at least one drive." }
	foreach($drive in $drives) {
		if(-not (Get-PSDrive $drive -ErrorAction SilentlyContinue)) {
			$driveToMount = $drive
			break;
		}
	}
	
	#all drives are in use, then unmount the first one
	if(-not $driveToMount) {
		$driveToMount = $drives[0]
	}
 
	$val = Get-ExecProcess -executablePath $vcdPath -arguments "/l=$driveToMount `"$isoPath`"" -waitForCompletion
	
	$psdrive = $null
 
	if($waitUntilDriveAvailable) {	
		$sw = new-object System.Diagnostics.Stopwatch
		$sw.Start();
		while(-not $psdrive -or ($psdrive -and -not (dir $psdrive.Root -erroraction silentlycontinue))) { 
			Write-Progress -PercentComplete -1 -Activity "Waiting for Drive $driveToMount to become available" -CurrentOperation "Waiting" -SourceId 1 -Status "Polling for drive readiness"
			$psdrive = (Get-PSDrive | where { $_.Name -like "$driveToMount" })
 
			[Threading.Thread]::Sleep(200)
			if($sw.Elapsed.TotalSeconds -gt 30) {Write-Warning "Timeout (30 seconds) waiting for drive to become ready"; break; }
		}
       
        Write-Progress -PercentComplete -1 -Activity "Waiting for Drive $driveToMount to become available" -CurrentOperation "Waiting" -completed -SourceId 1 -Status "Polling for drive readiness"
	}
	return $psdrive
}
 
 
function Get-VCDPSDrives() {
<#
	.SYNOPSIS
		Gets a list of all drive letters that Virtual Clone Drive uses
 
	.DESCRIPTION
		Gets a list of all drive letters that Virtual Clone Drive uses
 
	.EXAMPLE
		PS C:\> $drives = Get-VCDPSDrives
		
	.INPUTS
		None
 
	.OUTPUTS
		char[]
 
	.NOTES
		Requires that Virtual clone drive is installed
 
	.LINK
		Get-VCDMountIso
 
#>
 
	#need to get the drives that VCD uses
	$vcdKey = gi "Registry::HKEY_CURRENT_USER\Software\Elaborate Bytes\VirtualCloneDrive"
 
	if( -not $vcdKey) {
		throw "No Virtual Clone Drive letters are specified in HKEY_CURRENT_USER\Software\Elaborate Bytes\VirtualCloneDrive" 
	}
	
	$driveMask = [int]$vcdKey.GetValue("VCDDriveMask");
	
	$driveLetters = @();
	
	$start = [int][char]'A';
	$end = [int][char]'Z';
	for($letter = $start; $letter -le $end; $letter++)
	{
		if(1 -band $driveMask) {
			#found a letter
			$driveLetters += [char]$letter
		}
		
		$driveMask = [Shift]::Right($driveMask, 1)
	}
	$driveLetters
}
 
#Use this to wait a process to complete
function Get-ExecProcess([string]$executablePath, [string]$arguments, [switch]$waitForCompletion) {
	Write-Host ("Start at: " + [DateTime]::Now.ToString())
	write-host -for cyan "$executablePath ${arguments}"
	$continue = $true
	while($continue) {
		try {
			$process = [diagnostics.process]::start($executablePath, $arguments); 
			if($waitForCompletion) {
			    $process.WaitForExit(); 
		        Write-host "Exited with code: $($process.ExitCode)"
			}
			$continue = $false;
			break;
		} catch {
		
			if($_.Exception.Message.Contains("The wrong diskette is in the drive")) {
				Write-Warning $_.Exception
				Write-Warning "Retrying operation..."
				$continue = $true;
				[Threading.Thread]::Sleep(1000);
			} else {
				throw
			}
		}
	}
	Write-Host ("End at: " + [DateTime]::Now.ToString())
}