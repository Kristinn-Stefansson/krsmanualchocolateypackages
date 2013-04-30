# Global variables
$uninstallHives = @{ }

#
# Function to search for installed programs
#
function DoesInstalledProgramExist{
param(
[string]$SearchForName = "", 
[string]$SearchForGuid = "", 
[string]$SearchVersion = "", 
[string]$UninstallKeyIf32 = "HKLM:SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\", 
[string]$UninstallKeyIfNative = "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\",
[switch]$AppIs32bit = $FALSE,
[switch]$Search32and64Hive = $FALSE,
[switch]$help
)
      if ($help) {
        write-host "Function to search for installed program by name";
        write-host "-SearchForName - The pattern to match the name to";
        write-host "-SearchForGuid - The Uninstall GUID to match.";
        write-host "-SearchVersion - optionally the version to match for the name or guid.";
        write-host "-UninstallKeyIf32 - optionally specify the registry key to use for 32 bit programs (under 64 bit). Default searches under SOFTWARE\Wow6432Node.";
        write-host "-UninstallKeyIfNative - optionally specify the registry key to use for 32 bit programs. Default searches under SOFTWARE\Microsoft.";
        write-host "-AppIs32bit - optionally specify that the app is known to be 32 bit under 64 bit WOW. ";
        write-host "-Search32and64Hive - optionally specify both 32 bit and 64 registries should be searched. ";
        return
      }
    $UninstallKey = "";

    $foundUnder32bitHive = $FALSE;
    $foundUnderNativeHive = $FALSE;
    $os=Get-WMIObject win32_operatingsystem;
    $is64Bit = ($os.OSArchitecture -eq "64-bit");

    if ( $is64Bit -and ( ( $AppIs32bit -eq $TRUE ) -or ( $Search32and64Hive -eq $TRUE ) ) ) 
    {
        $foundUnder32bitHive = SearchUninstall $SearchForName $UninstallKeyIf32 $SearchVersion;
    }
    if ( ( $foundUnder32bitHive -eq $FALSE ) -and ( ( $is64Bit -eq $FALSE ) -or ( $AppIs32bit -eq $FALSE) -or ( $Search32and64Hive -eq $TRUE ) ) )
    {
        $foundUnderNativeHive = SearchUninstall $SearchForName $UninstallKeyIfNative $SearchVersion;
    }

	( $foundUnder32bitHive -or $foundUnderNativeHive )
}
#
# Function to search for uninstall keys
#
function SearchUninstall([string]$SearchFor="", [string]$UninstallKey="", [string]$Version="")
{
	if($uninstallHives.Contains($UninstallKey) -eq $FALSE)
	{
		$uO = ls -path $UninstallKey;
		$uninstallHives.Add($UninstallKey, $uO);
	}
    $uninstallObjects = $uninstallHives[$UninstallKey];
    $found = $FALSE;

    foreach($uninstallEntry in $uninstallObjects)
    {
       $entryProperty = Get-ItemProperty -path registry::$uninstallEntry;
       if($entryProperty.DisplayName -like $SearchFor)
        {       
           $found = $TRUE -and ( ($Version -eq "") -or ($entryProperty.DisplayVersion -ge $Version) );
           break;
        }
    }
    $found;
}

function SearchRegistryByVersion($SearchVersion, $PathKey)
{
	$installObjects = ls -path $PathKey;
	$found = $FALSE;

	foreach($installEntry in $installObjects)
	{
		$entryProperty = Get-ItemProperty -path registry::$installEntry
	   
		if($entryProperty.psobject.Properties -ne $null -and $entryProperty.psobject.Properties["(default)"].value -eq $searchVersion)
		{
			$found = $TRUE;
			break;
		}
	}

	$found;
}

function IsLoadUserProfileEnabled ($applicationPool) {
    $actualDir = Get-Location
    $dir = $env:windir + "\system32\inetsrv"

    Set-Location $dir
    $IsLoadUserProfileEnabled = .\appcmd.exe list apppools /name:$applicationPool /processModel.loadUserProfile:true

    Set-Location $actualDir

    ($IsLoadUserProfileEnabled -ne $NULL);
}

