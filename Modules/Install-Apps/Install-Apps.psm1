#region Java
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
"INSTALLDIR=C:\Program Files\Java\jdk_16.0.1" | Add-Content $javainstallfile
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
#endregion
#region PacketTracer
function Install-PacketTracer{
    Param(
        [Parameter(Position=0, Mandatory)]
        [string]$short
    )

    $quest = "Packet Tracer zal beginnen installeren"
        
    $titel = $null
    if (![string]::IsNullOrWhiteSpace($quest)) {
        #De lengte van de keuze wordt gemeten zodat de onderscheiding goed kan gemaakt worden
        $lengte = [math]::Max(($keuzes | Measure-Object -Maximum -Property Length).Maximum, $quest.Length)
        $titel = '{0}{1}{2}{3}' -f $quest, [Environment]::NewLine, ('=' * $lengte), [Environment]::NewLine
    }

    $installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName | 
    Where { ($_.DisplayName -like "*Packet Tracer*")}) -ne $null

    Clear-Host
    Write-Host $titel
    Write-Host

    if (-not $installed) {

        $ptname = "packettracerinstaller.exe"
        $directory    = ($env:USERPROFILE + "\Downloads").ToString() #Bureablad van user
        $ptfile = "$directory\$ptname"
        $source = "https://archive.org/download/packet-tracer-800-build-212-mac-notarized/PacketTracer800_Build212_64bit_setup-signed.exe"

        #Zonder dit commando kan het niet download omdat er geen veilig SSL/TLS kanaal is
        [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"

        #File downloaden en plaatsen naar pad
        Write-Host "Starting Packet Tracer Download" -ForegroundColor Yellow
        Invoke-WebRequest -Uri $source -OutFile $ptfile
        Write-Host "Download completed" -ForegroundColor Green
        Write-Host ""
        Write-Host "Starting Packet Tracer Installation" -ForegroundColor Yellow
        cd $directory

        switch ($short) {
            "Ja" {               
                .\packettracerinstaller.exe /VERYSILENT /NORESTART
                timeout 60              
             }
            "Nee" {
                .\packettracerinstaller.exe /VERYSILENT /NORESTART /MERGETASKS=!desktopicon
                timeout 60           
            }
        }
        Write-Host "Installation Completed" -ForegroundColor Green
        Write-Host ""
        Write-Host "Removing files" -ForegroundColor Yellow
        Remove-Item $ptfile
        Write-Host "Files removed" -ForegroundColor Green
        Write-Host
    }
    else{
        Write-Warning "Applicatie staat al op de computer"
    }

}
#endregion
#region VisualParadigm
function Install-VisualParadigm{
    Param(
        [Parameter(Position=0, Mandatory)]
        [string]$short
    )

    $quest = "Visual Paradigm zal beginnen installeren"
        
    $titel = $null
    if (![string]::IsNullOrWhiteSpace($quest)) {
        #De lengte van de keuze wordt gemeten zodat de onderscheiding goed kan gemaakt worden
        $lengte = [math]::Max(($keuzes | Measure-Object -Maximum -Property Length).Maximum, $quest.Length)
        $titel = '{0}{1}{2}{3}' -f $quest, [Environment]::NewLine, ('=' * $lengte), [Environment]::NewLine
    }

    Clear-Host
    Write-Host $titel
    Write-Host
    

$installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName | 
    Where { ($_.DisplayName -like "*Paradigm*")}) -ne $null


if (-not $installed) {

#Variables
$file = "installconfig.zip"
$directory =  ($env:USERPROFILE + "\Downloads").ToString()  #Bureablad van user
$fullfile = "$directory\$file"
$source = "https://knowhow.visual-paradigm.com/know-how_files/2016/08/install_config_20200115.zip"

$vp = "Visual_Paradigm_16.3_Win64.exe"
$vpfile = "$directory\$vp"
$vpsource = "https://www.visual-paradigm.com/downloads/vp/Visual_Paradigm_Win64.exe" #https://www.visual-paradigm.com/download/community.jsp?platform=windows&arch=64bit

$file = "installconfig.zip"
$fullfile = "$directory\$file"

$vpinstallfile = "$directory\$vp"
$installfile = "$directory\install_config.xml"
$installationfile = "$directory\vp_installer.log"
#Zonder dit commando kan het niet download omdat er geen veilig SSL/TLS kanaal is
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"

#VP Download
Write-Host "Starting Visual Paradigm Download" -ForegroundColor Yellow
Invoke-WebRequest -Uri $vpsource -OutFile $vpfile
Write-Host "Download Completed" -ForegroundColor Green

#Silent Install download
Write-Host "Starting File Download" -ForegroundColor Yellow
Invoke-WebRequest -Uri $source -OutFile $fullfile
Write-Host "Download completed" -ForegroundColor Green
Write-Host ""

#Extract  File
Write-Host "Extracting File" -ForegroundColor Yellow
Expand-Archive -LiteralPath $fullfile -DestinationPath $directory
Write-Host "Extract completed" -ForegroundColor Green
Write-Host ""

# Remove ZIP
Write-Host "Removing File" -ForegroundColor Yellow
Remove-Item $fullfile
Write-Host "File Removed" -ForegroundColor Green
Write-Host ""

#Installatie
Write-Host "Starting Visual Paradigm Installation" -ForegroundColor Yellow
cd $directory
.\Visual_Paradigm_16.3_Win64.exe -q -dir "C:\Program Files\Visual Paradigm" -Wait


Sleep 200
Write-Host "Installation Complete" -ForegroundColor Green
Write-Host ""

#Remove files
Write-Host "Removing File" -ForegroundColor Yellow
Remove-Item $vpinstallfile -Force
Write-Host "File Removed" -ForegroundColor Green
Write-Host ""

Write-Host "Removing File" -ForegroundColor Yellow
Remove-Item $installfile
Write-Host "File Removed" -ForegroundColor Green
Write-Host ""

Write-Host "Removing File" -ForegroundColor Yellow
Remove-Item $installationfile
Write-Host "File Removed" -ForegroundColor Green
Write-Host ""

if($short.Equals("Ja")){
        $vpshortcutsource = "C:\Program Files\Visual Paradigm\bin\Visual Paradigm.exe"
        $vpshortcutlocation = ($env:USERPROFILE + "\Desktop\Visual Paradigm.lnk").ToString() 
        $WScriptShell = New-Object -ComObject WScript.Shell
        $vpShortcut = $WScriptShell.CreateShortcut($vpshortcutlocation)
        $vpShortcut.TargetPath = $vpshortcutsource
        $vpShortcut.Save()
}
    
}
else{
    Write-Warning "Applicatie staat al op de computer"
}

}
#endregion