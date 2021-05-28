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
    try{ 
    $installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName | 
    Where { ($_.DisplayName -like "*Packet Tracer*")}) -ne $null
    } Catch [System.InvalidCastException]{
        Write-Warning "Kon gegevens niet lezen van registry"
        $installed = $false
    }
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