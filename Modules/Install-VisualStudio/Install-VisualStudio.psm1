function Install-VisualStudio{
    Param(
        [Parameter(Position=0, Mandatory)]
        [string]$short
    )

    $quest = "Visual Studio Code zal beginnen installeren"
        
    $titel = $null
    if (![string]::IsNullOrWhiteSpace($quest)) {
        #De lengte van de keuze wordt gemeten zodat de onderscheiding goed kan gemaakt worden
        $lengte = [math]::Max(($keuzes | Measure-Object -Maximum -Property Length).Maximum, $quest.Length)
        $titel = '{0}{1}{2}{3}' -f $quest, [Environment]::NewLine, ('=' * $lengte), [Environment]::NewLine
    }

    $installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -like "*Visual Studio Code*"}) -ne $null

    Clear-Host
    Write-Host $titel
    Write-Host
    
    if (-not $installed) {
    
        switch ($short) {
            "Ja" { 
                choco install vscode 
             }
            "Nee" {
                choco install vscode --params "/NoDesktopIcon"  
            }
        }
    }
    else{
        Write-Warning "Applicatie staat al op de computer"
        Sleep 3
    }

}