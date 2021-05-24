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