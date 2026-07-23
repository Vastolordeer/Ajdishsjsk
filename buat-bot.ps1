$base = "C:\WINDOWS\system32\Earnpt-Automation"

for ($i = 2; $i -le 4; $i++) {

    $dest = "C:\WINDOWS\system32\Earnpt-Automation-$i"

    if (!(Test-Path $dest)) {
        Copy-Item $base $dest -Recurse -Force
        Write-Host "Created $dest"
    } else {
        Write-Host "$dest already exists"
    }

    $envFile = Join-Path $dest ".env"
    $port = 9221 + $i

    (Get-Content $envFile) |
    ForEach-Object {
        $_ `
        -replace '^CHROME_PROFILE_DIRECTORY=.*$', "CHROME_PROFILE_DIRECTORY=Profile $i" `
        -replace '^CHROME_DEBUG_PORT=.*$', "CHROME_DEBUG_PORT=$port"
    } | Set-Content $envFile

    Write-Host "Profile $i -> Port $port"
}

Write-Host ""
Write-Host "=============================="
Write-Host "Done!"
Write-Host "Bot1 : Profile 1 / Port 9222"
Write-Host "Bot2 : Profile 2 / Port 9223"
Write-Host "Bot3 : Profile 3 / Port 9224"
Write-Host "Bot4 : Profile 4 / Port 9225"
Write-Host "=============================="
