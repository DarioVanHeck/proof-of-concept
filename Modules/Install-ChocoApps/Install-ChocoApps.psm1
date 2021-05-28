function Install-ChocoApps{
    Param(
        [Parameter(Position=0, Mandatory)]
        [string]$short,
        [string]$choconame,
        [string]$appname,
        [string]$exenaam
    )

    $quest = "$appname zal beginnen installeren"
    try{    
    $titel = $null
    if (![string]::IsNullOrWhiteSpace($quest)) {
        #De lengte van de keuze wordt gemeten zodat de onderscheiding goed kan gemaakt worden
        $lengte = [math]::Max(($quest | Measure-Object -Maximum -Property Length).Maximum, $quest.Length)
        $titel = '{0}{1}{2}{3}' -f $quest, [Environment]::NewLine, ('=' * $lengte), [Environment]::NewLine
    }

    if($choconame.Equals("eclipse")){
        $installed = Get-ChildItem -Path C:\ -Include "eclipse.exe" -File -Recurse -ErrorAction SilentlyContinue
    }
    else{
        $installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -like "*$appname*"}) -ne $null
    }
        } Catch [System.InvalidCastException]{
            Write-Warning "Kon gegevens niet lezen van registry"
            $installed = $false
        }
    Clear-Host
    Write-Host $titel
    Write-Host
    
    if (-not $installed) {
    
        switch ($short) {
            "Ja" { 
                choco install $choconame 
                
                if($choconame.Contains("eclipse") -or $choconame.Contains("mysql.workbench") -or $choconame.Contains("git") ){
                    $path = Get-ChildItem "C:\" -Recurse -Filter "$exenaam.exe" -Name
                    $shortcutlocation = ($env:USERPROFILE + "\Desktop\$appname.lnk").ToString() 
                    $WScriptShell = New-Object -ComObject WScript.Shell
                    $Shortcut = $WScriptShell.CreateShortcut($shortcutlocation)
                    $Shortcut.TargetPath = $path
                    $Shortcut.Save()
                }

             }
            "Nee" {
                choco install $choconame  --params "/NoDesktopIcon /NoDesktopShortcut"
                
                if($choconame.Contains("scenebuilder")){
                    Remove-Item ($env:USERPROFILE + "\Desktop\$appname.lnk").ToString()
                } 
            }
        }
    }
    else{
        Write-Warning "Applicatie staat al op de computer"
        Write-Warning "Checking for updates"

        if($choconame.Contains("git")){
            try  {     
                git update-git-for-windows
                $erroractionpreference = "Stop"
            }
            catch [System.Management.Automation.RemoteException]{
                Write-Host ""
                Write-Warning "Git is al up-to-date"
            } 
        }
        if($choconame.Contains("vscode")){
            code --install-extension "esbenp.prettier-vscode"
            code --install-extension "ritwickdey.live-sass"
            code --install-extension "ritwickdey.liveserver"
        }

        Sleep 3
    }

}
