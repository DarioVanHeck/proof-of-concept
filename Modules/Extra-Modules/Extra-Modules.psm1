#region space
function Space {
    $drivespace = gwmi win32_logicaldisk | where DeviceID -eq "C:" | Select FreeSpace
    $getfullproperty = $drivespace | Select -ExpandProperty "FreeSpace"
    $getnumber = ($getfullproperty/1GB)
    $freespace = [math]::Round($getnumber, 2)
    
    return $freespace
    }
#endregion
#region keuze
function Keuze-Menu {
    Param(
        [Parameter(Position=0, Mandatory=$True)]
        [string[]]$keuzes,
        [string] $vraag
    )

    $titel = $null
    if (![string]::IsNullOrWhiteSpace($vraag)) {
        #De lengte van de keuze wordt gemeten zodat de onderscheiding goed kan gemaakt worden
        $lengte = [math]::Max(($keuzes | Measure-Object -Maximum -Property Length).Maximum, $vraag.Length)
        $titel = '{0}{1}{2}{3}' -f $vraag, [Environment]::NewLine, ('=' * $lengte), [Environment]::NewLine
    }

    $choices = (49..57)| ForEach-Object { [char]$_ }
    $i = 0
    $items = ($keuzes | ForEach-Object { '[{0}]  {1}' -f $choices[$i++], $_ }) -join [Environment]::NewLine

    # Clear output en toon menu
    while ($true) {
        Clear-Host
        Write-Host $titel
        Write-Host $items
        Write-Host

        $keuze = (Read-Host -Prompt 'Selecteer je keuze')
        $index  = $choices.IndexOf($keuze[0])

        if ($index -ge 0 -and $index -lt $keuzes.Count) {
            return $keuzes[$index]
        }
        else {
            Write-Warning "Ongeldige keuze, probeer opnieuw"
            Start-Sleep -Seconds 2
        }
    }
}
#endregion
#region meerkeuze
function Meer-Keuze {
    Param(
        [Parameter(Position=0, Mandatory)]
        [string[]]$opties,

        [Parameter(Position=0, Mandatory)]
        [string] $vraag
    )

    $keuzes = New-Object System.Collections.Generic.List[System.Object]

    $titel = $null
    if (![string]::IsNullOrWhiteSpace($vraag)) {
        #De lengte van de keuze wordt gemeten zodat de onderscheiding goed kan gemaakt worden
        $lengte = [math]::Max(($keuzes | Measure-Object -Maximum -Property Length).Maximum, $vraag.Length)
        $titel = '{0}{1}{2}{3}' -f $vraag, [Environment]::NewLine, ('=' * $lengte), [Environment]::NewLine
    }

    # display the menu and return the chosen option
    
        Clear-Host
        Write-Host $titel
        Write-Host

        For ($i = 0; $i -lt $opties.Count; $i++){
            $antwoord = (Read-Host -Prompt $opties[$i])

            while(!(($antwoord.ToUpper().Equals("Y")) -or ($antwoord.ToUpper().Equals("N")))){
                Write-Warning "Gelieve een geldige keuze te maken door Y of N in te vullen "
                Write-Host ""
                $antwoord = (Read-Host -Prompt $opties[$i])
            }
            $keuzes.Add($antwoord)
        }
        return $keuzes

}
#endregion