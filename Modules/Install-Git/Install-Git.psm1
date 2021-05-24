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