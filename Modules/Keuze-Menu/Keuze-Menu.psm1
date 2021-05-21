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

    # possible choices: didits 1 to 9, characters A to Z
    $choices = (49..57)| ForEach-Object { [char]$_ }
    $i = 0
    $items = ($keuzes | ForEach-Object { '[{0}]  {1}' -f $choices[$i++], $_ }) -join [Environment]::NewLine

    # display the menu and return the chosen option
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