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