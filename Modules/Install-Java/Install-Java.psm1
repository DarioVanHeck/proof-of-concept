function Install-Java{

    $quest = "Java zal beginnen installeren"
        
    $titel = $null
    if (![string]::IsNullOrWhiteSpace($quest)) {
        #De lengte van de keuze wordt gemeten zodat de onderscheiding goed kan gemaakt worden
        $lengte = [math]::Max(($keuzes | Measure-Object -Maximum -Property Length).Maximum, $quest.Length)
        $titel = '{0}{1}{2}{3}' -f $quest, [Environment]::NewLine, ('=' * $lengte), [Environment]::NewLine
    }

    Clear-Host
    Write-Host $titel
    Write-Host
    
    $installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -like "*Development Kit 16*"}) -ne $null

if(-not $installed){
#region Java
$java = "JDKinstaller.exe"
$directory    = ($env:USERPROFILE + "\Downloads").ToString() #Bureablad van user
$javafile = "$directory\$java"
$javainstallfile = "$directory\JavaInstallConfig.txt"
$javasource = "https://download.oracle.com/otn-pub/java/jdk/16.0.1+9/7147401fd7354114ac51ef3e1328291f/jdk-16.0.1_windows-x64_bin.exe"



#File downloaden en plaatsen naar pad
Write-Host "Starting Java Download" -ForegroundColor Yellow
$client = new-object System.Net.WebClient 
$cookie = "oraclelicense=accept-securebackup-cookie"
$client.Headers.Add([System.Net.HttpRequestHeader]::Cookie, $cookie) 
$client.downloadFile($javasource, $javafile)
Write-Host "Download completed" -ForegroundColor Green
Write-Host ""



#Maak een install file voor silent install
"INSTALL_SILENT=Enable" | Set-Content $javainstallfile
"INSTALLDIR=C:\Program Files\Java\jdk_16.0.1" | Add-Content $javainstallfile #was \java
"AUTO_UPDATE=Enable" | Add-Content $javainstallfile
"WEB_JAVA_SECURITY_LEVEL=VH" | Add-Content $javainstallfile
 

#Start installatie Java
Write-Host "Starting Java Installation" -ForegroundColor Yellow
Start-Process $javafile INSTALLCFG=$javainstallfile -Wait
Write-Host "Java Installed Sucessfully" -ForegroundColor Green
Write-Host ""

#Verwijder de installatie files
Write-Host "Removing Installers" -ForegroundColor Yellow
if (Test-Path $javafile) {
    Remove-Item $javafile
  }

  if (Test-Path $javainstallfile) {
    Remove-Item $javainstallfile 
  }
Write-Host "Installers have been removed" -ForegroundColor Green
write-Host ""
}
else{
    Write-Warning "Java JDK 16.0.1 staat al op de computer"
    Sleep 3
}
#endregion

}