    $bots = @(
    @{ Path="C:\WINDOWS\system32\Earnpt-Automation";   UserData="C:\ChromeBot1"; Port=9222 },
    @{ Path="C:\WINDOWS\system32\Earnpt-Automation-2"; UserData="C:\ChromeBot2"; Port=9223 },
    @{ Path="C:\WINDOWS\system32\Earnpt-Automation-3"; UserData="C:\ChromeBot3"; Port=9224 },
    @{ Path="C:\WINDOWS\system32\Earnpt-Automation-4"; UserData="C:\ChromeBot4"; Port=9225 }
)

foreach($bot in $bots){

    $envFile = Join-Path $bot.Path ".env"
    $ps1File = Join-Path $bot.Path "start-real-chrome-profile1-debug.ps1"

    if(!(Test-Path $envFile)){
        Write-Host "Skip $envFile"
        continue
    }

    New-Item -ItemType Directory -Force -Path $bot.UserData | Out-Null
        $env = Get-Content $envFile

    $env = $env | Where-Object {
        $_ -notmatch "^CHROME_USER_DATA_DIR="
    }

    $env += "CHROME_USER_DATA_DIR=$($bot.UserData)"

    $env = $env | ForEach-Object {

        if($_ -match "^CHROME_DEBUG_PORT="){
            "CHROME_DEBUG_PORT=$($bot.Port)"
        }else{
            $_
        }

    }

    Set-Content $envFile $env
        $content = Get-Content $ps1File -Raw

    $old = '$userDataDir = Join-Path $chromeUserHome ''AppData\Local\Google\Chrome\User Data'''

    $new = @'
$userDataDir = if ($envValues.CHROME_USER_DATA_DIR) {
    $envValues.CHROME_USER_DATA_DIR
} else {
    Join-Path $chromeUserHome 'AppData\Local\Google\Chrome\User Data'
}
'@

    $content = $content.Replace($old,$new)
        Set-Content $ps1File $content

    Write-Host ""
    Write-Host "================================"
    Write-Host "Patched $($bot.Path)"
    Write-Host "UserData : $($bot.UserData)"
    Write-Host "Port     : $($bot.Port)"
    Write-Host "================================"
}
