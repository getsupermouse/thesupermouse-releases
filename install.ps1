# THE SUPER MOUSE — 1-Click Fast Windows Installer
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Clear-Host
Write-Host ""
Write-Host "  =======================================================" -ForegroundColor Green
Write-Host "               THE SUPER MOUSE — Windows Setup           " -ForegroundColor White
Write-Host "  =======================================================" -ForegroundColor Green
Write-Host ""

$installDir = "$env:LOCALAPPDATA\TheSuperMouse"
$zipPath = "$env:TEMP\TheSuperMouse_Full.zip"
$downloadUrl = "https://raw.githubusercontent.com/getsupermouse/supermousenewnupdates/main/updates/TheSuperMouse_Full.zip"

Write-Host "  [*] Downloading THE SUPER MOUSE from GitHub..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath -UseBasicParsing

Write-Host "  [*] Installing to $installDir..." -ForegroundColor Cyan
if (Test-Path $installDir) {
    Remove-Item $installDir -Recurse -Force -ErrorAction SilentlyContinue
}
New-Item -ItemType Directory -Path $installDir -Force | Out-Null
Expand-Archive -Path $zipPath -DestinationPath $installDir -Force
Remove-Item $zipPath -Force -ErrorAction SilentlyContinue

# Create Desktop Shortcut
$wsh = New-Object -ComObject WScript.Shell
$desktop = [System.Environment]::GetFolderPath('Desktop')
$shortcut = $wsh.CreateShortcut("$desktop\THE SUPER MOUSE.lnk")
$shortcut.TargetPath = "$installDir\TheSuperMouse\main_app.py"
if (-not (Test-Path $shortcut.TargetPath)) {
    $shortcut.TargetPath = "$installDir\TheSuperMouse\TheSuperMouse.exe"
}
$shortcut.WorkingDirectory = "$installDir\TheSuperMouse"
$shortcut.Save()

Write-Host "  [+] INSTALLED SUCCESSFULLY! Desktop shortcut created." -ForegroundColor Green
Write-Host "  [*] Launching THE SUPER MOUSE..." -ForegroundColor Yellow
Start-Process $shortcut.TargetPath
