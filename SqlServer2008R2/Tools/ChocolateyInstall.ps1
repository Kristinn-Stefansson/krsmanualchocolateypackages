try
{
    $adminFile = (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'ConfigurationFile.ini')
    Write-Host "Creating a local SqlServiceRunner account."
    $user = "SqlServiceRunner"
    $password = "SqlServ1ceRunner"
    $previous = [ADSI]"WinNT://$env:COMPUTERNAME/$user"
    if($previous.distinquishedName -eq $null)
    {
        $objOu = [ADSI]"WinNT://$env:COMPUTERNAME"    
        $objUser = $objOU.Create("User", $user)    
        $objUser.setpassword($password)    
        $objUser.SetInfo()    
        $objUser.description = "Sql Service Runner"
        $objUser.Put("PasswordExpired", 0) 
        $objUser.SetInfo()
        $objUser.Put("UserFlags", 0x10000)
        $objUser.SetInfo()
        [ADSI]$group="WinNT://$env:COMPUTERNAME/Users,Group"
        $group.Add($objUser.path)
    }
    else
    {
        $previous.setpassword($password) 
        $previous.SetInfo()
        $previous.Put("PasswordExpired", 0) 
        $previous.SetInfo()
        $previous.Put("UserFlags", 0x10000)        
        $previous.SetInfo()
        Write-Host "User $user already exists, the password was reset to $password."
    }
    Install-ChocolateyInstallPackage 'SqlServer2008R2' 'exe' "/SQLSVCPASSWORD=`"$password`" /SAPWD=`"$password`" /ISSVCPASSWORD=`"$password`" /AGTSVCPASSWORD=`"$password`" /ConfigurationFile=`"$adminFile`"" 'C:\Disks\DownloadedMSDN\SQL2008R2\en_sql_server_2008_r2_developer_x86_x64_ia64_dvd_522665\Setup.exe'
    $setupProcess = (Get-Process | Where-Object { $_.ProcessName -ieq "Setup" }) 
    if( $setupProcess -ne $NULL)
    {
        Write-Host "Waiting for Sql Server install to finish. If an exit dialog pops up, you will need to close it to finish."
        $setupProcess.WaitForExit() 
    }
    Install-ChocolateyInstallPackage 'SqlServer2008R2SP2' 'exe' "/ConfigurationFile=$adminFile" 'C:\Disks\DownloadedMSDN\SQL2008R2SP2\SQLServer2008R2SP2-KB2630458-x64-ENU.exe'
    Write-ChocolateySuccess 'SqlServer2008R2'
} catch {
    Write-ChocolateyFailure 'SqlServer2008R2' $($_.Exception.Message)
    throw
}