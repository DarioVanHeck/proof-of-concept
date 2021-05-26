function Install-Chocolatey{
    Write-Host "Trying to install Chocolatey" -ForegroundColor Yellow
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    
    #Changing Feature
    #Deze feauture zorgt ervoor dat de extra nodige package automatisch geaccepteerd worden
    Write-Host "Changing Chocolatey Feature" -ForegroundColor Yellow
    choco feature enable -n allowGlobalConfirmation
    Write-Host "Feature Changed" -ForegroundColor Green
    Write-Host ""
}
#region eclipse
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
#endregion
#region Git
function Install-Git{
    Param(
        [Parameter(Position=0, Mandatory)]
        [string]$short
    )

    $quest = "Git zal beginnen installeren"
        
    $titel = $null
    if (![string]::IsNullOrWhiteSpace($quest)) {
        #De lengte van de keuze wordt gemeten zodat de onderscheiding goed kan gemaakt worden
        $lengte = [math]::Max(($keuzes | Measure-Object -Maximum -Property Length).Maximum, $quest.Length)
        $titel = '{0}{1}{2}{3}' -f $quest, [Environment]::NewLine, ('=' * $lengte), [Environment]::NewLine
    }

    $installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -like "*git*"}) -ne $null

    Clear-Host
    Write-Host $titel
    Write-Host
    
    if (-not $installed) {
    
        switch ($short) {
            "Ja" { 
                choco install git 

                $gitsource = "C:\Program Files\Git\git-bash.exe"
                            $gitshortcutlocation = ($env:USERPROFILE + "\Desktop\Git.lnk").ToString() 
                            $WScriptShell = New-Object -ComObject WScript.Shell
                            $gitShortcut = $WScriptShell.CreateShortcut($gitshortcutlocation)
                            $gitShortcut.TargetPath = $gitsource
                            $gitShortcut.Save()
             }
            "Nee" {
                choco install git  
            }
        }
    }
    else{
        Write-Warning "Applicatie staat al op de computer"
        Write-Warning "Checking for updates"

        try  {     
            git update-git-for-windows
            $erroractionpreference = "Stop"
        }
        catch [System.Management.Automation.RemoteException]{
            Write-Host ""
            Write-Warning "Git is al up-to-date"
        } 
        Sleep 3
    }

}
#endregion
#region scenebuilder
function Install-SceneBuilder{
    Param(
        [Parameter(Position=0, Mandatory)]
        [string]$short
    )

    $quest = "SceneBuilder zal beginnen installeren"
        
    $titel = $null
    if (![string]::IsNullOrWhiteSpace($quest)) {
        #De lengte van de keuze wordt gemeten zodat de onderscheiding goed kan gemaakt worden
        $lengte = [math]::Max(($keuzes | Measure-Object -Maximum -Property Length).Maximum, $quest.Length)
        $titel = '{0}{1}{2}{3}' -f $quest, [Environment]::NewLine, ('=' * $lengte), [Environment]::NewLine
    }

    $installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -like "*scenebuilder*"}) -ne $null

    Clear-Host
    Write-Host $titel
    Write-Host
    
    if (-not $installed) {
    
        switch ($short) {
            "Ja" { 
                choco install scenebuilder
             }
            "Nee" {
                choco install scenebuilder

                $directory = ($env:USERPROFILE + "\Desktop").ToString()
                $dir = "$directory\SceneBuilder.lnk"
                Remove-Item -LiteralPath $dir
            }
        }
    }
    else{
        Write-Warning "Applicatie staat al op de computer"
        Sleep 3
    }

}
#endregion
#region SQLWorkbench
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
#endregion
#region VirtualBox
function Install-VirtualBox{
    Param(
        [Parameter(Position=0, Mandatory)]
        [string]$short
    )

    $quest = "VirtualBox zal beginnen installeren"
        
    $titel = $null
    if (![string]::IsNullOrWhiteSpace($quest)) {
        #De lengte van de keuze wordt gemeten zodat de onderscheiding goed kan gemaakt worden
        $lengte = [math]::Max(($keuzes | Measure-Object -Maximum -Property Length).Maximum, $quest.Length)
        $titel = '{0}{1}{2}{3}' -f $quest, [Environment]::NewLine, ('=' * $lengte), [Environment]::NewLine
    }

    $installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName | 
    Where { ($_.DisplayName -like "*virtualbox*" -and $_.DisplayName -cnotlike "*Guest*")}) -ne $null

    Clear-Host
    Write-Host $titel
    Write-Host

    if (-not $installed) {
    
        switch ($short) {
            "Ja" { 
               choco install virtualbox 
             }
            "Nee" {
                choco install virtualbox --params "/NoDesktopShortcut"
            }
        }
    }
    else{
        Write-Warning "Applicatie staat al op de computer"
        Sleep 3
    }

}
#endregion
#region
function Install-VisualStudio{
    Param(
        [Parameter(Position=0, Mandatory)]
        [string]$short
    )

    function Install-Extensions{
            Param(
            [Parameter(Position=0, Mandatory)]
            [string[]] $extensions
            )

            for($i=0; $i -lt $extensions.Length; $i++){
                try  {     
                    code --install-extension $extensions[$i]
                }
                catch [System.Management.Automation.RemoteException]{
                
                    Write-Host "Extension Installed" -ForegroundColor Green
                    Write-Host ""
                } 
            }  
    }

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

        #$ex = "esbenp.prettier-vscode","ritwickdey.liveserver","ritwickdey.live-sass"
        #Install-Extensions -extensions $ex

    }
    else{
        Write-Warning "Applicatie staat al op de computer"
        
        $extensions = code --list-extensions


        if($extensions -NotContains "esbenp.prettier-vscode" ){
        $ex = "esbenp.prettier-vscode"
        Install-Extensions -extensions $ex
        }
        if($extensions -NotContains "ritwickdey.live-sass" ){
        $ex = "ritwickdey.liveserver"
        Install-Extensions -extensions $ex
        }
        if($extensions -NotContains "ritwickdey.liveserver" ){
        $ex = "ritwickdey.live-sass"
        Install-Extensions -extensions $ex
        }
            
    }

}
#endregion