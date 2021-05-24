function Install-SQLWorkbench{
    Param(
        [Parameter(Position=0, Mandatory)]
        [string]$short
    )

    $quest = "MySQL Workbench zal beginnen installeren"
        
    $titel = $null
    if (![string]::IsNullOrWhiteSpace($quest)) {
        #De lengte van de keuze wordt gemeten zodat de onderscheiding goed kan gemaakt worden
        $lengte = [math]::Max(($keuzes | Measure-Object -Maximum -Property Length).Maximum, $quest.Length)
        $titel = '{0}{1}{2}{3}' -f $quest, [Environment]::NewLine, ('=' * $lengte), [Environment]::NewLine
    }

    $installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -like "*workbench*"}) -ne $null

    Clear-Host
    Write-Host $titel
    Write-Host
    
    if (-not $installed) {
    
        switch ($short) {
            "Ja" { 
                choco install mysql.workbench 

                $sqlsource = "C:\Program Files\MySQL\MySQL Workbench 8.0 CE\MySQLWorkbench.exe"
                            $sqlshortcutlocation = ($env:USERPROFILE + "\Desktop\MySQL Workbench.lnk").ToString() 
                            $WScriptShell = New-Object -ComObject WScript.Shell
                            $sqlShortcut = $WScriptShell.CreateShortcut($sqlshortcutlocation)
                            $sqlShortcut.TargetPath = $sqlsource
                            $sqlShortcut.Save()
             }
            "Nee" {
                choco install mysql.workbench  
            }
        }
    }
    else{
        Write-Warning "Applicatie staat al op de computer"
        Sleep 3
    }

}