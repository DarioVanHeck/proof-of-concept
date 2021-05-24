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


timeout 200
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