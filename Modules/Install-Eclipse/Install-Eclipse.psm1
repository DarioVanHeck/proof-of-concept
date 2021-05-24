function Install-Eclipse{
    Param(
        [Parameter(Position=0, Mandatory)]
        [string]$short
    )

    $quest = "Eclipse zal beginnen installeren"
        
    $titel = $null
    if (![string]::IsNullOrWhiteSpace($quest)) {
        #De lengte van de keuze wordt gemeten zodat de onderscheiding goed kan gemaakt worden
        $lengte = [math]::Max(($keuzes | Measure-Object -Maximum -Property Length).Maximum, $quest.Length)
        $titel = '{0}{1}{2}{3}' -f $quest, [Environment]::NewLine, ('=' * $lengte), [Environment]::NewLine
    }

    $installed = Get-ChildItem -Path C:\ -Include "eclipse.exe" -File -Recurse -ErrorAction SilentlyContinue

    Clear-Host
    Write-Host $titel
    Write-Host

    if (-not $installed) {
        switch ($short) {
            "Ja" { 
               choco install eclipse 

                            $eclipsesource = "C:\Program Files\Eclipse 4.19\eclipse\eclipse.exe"
                            $shortcutlocation = ($env:USERPROFILE + "\Desktop\Eclipse.lnk").ToString() 
                            $WScriptShell = New-Object -ComObject WScript.Shell
                            $Shortcut = $WScriptShell.CreateShortcut($shortcutlocation)
                            $Shortcut.TargetPath = $eclipsesource
                            $Shortcut.Save()
             }
            "Nee" {
                choco install eclipse
            }
        }
    }
    else{
        Write-Warning "Applicatie staat al op de computer"
        Sleep 3
    }

}