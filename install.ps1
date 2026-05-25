# Windows Migration & Cleanup Script for Auto-Paste Image Plugin
# Transitioning to native Antigravity CLI 'Ctrl + V' and 'Esc' support

Write-Host "🔄 Initializing Migration and Cleanup to Native Clipboard..." -ForegroundColor Cyan

# 1. Remove Startup Shortcut
$StartupDir = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs\Startup"
$ShortcutPath = Join-Path $StartupDir "PasteImage.lnk"

if (Test-Path $ShortcutPath) {
    Write-Host "🧹 Found old custom startup shortcut. Removing..." -ForegroundColor Yellow
    Remove-Item -Path $ShortcutPath -Force
    Write-Host "✅ Startup shortcut removed successfully." -ForegroundColor Green
} else {
    Write-Host "✅ No custom startup shortcut found." -ForegroundColor Green
}

# 2. Remove script files from .local/bin
$BinDir = Join-Path $env:USERPROFILE ".local\bin"
$ScriptFiles = @("auto_paste_img.ps1", "auto_paste_img.ahk")

foreach ($file in $ScriptFiles) {
    $FilePath = Join-Path $BinDir $file
    if (Test-Path $FilePath) {
        Write-Host "🧹 Removing obsolete script file at: $FilePath" -ForegroundColor Yellow
        Remove-Item -Path $FilePath -Force
    }
}

# 3. Clean up temporary directory
$TmpDir = Join-Path $env:TEMP "antigravity_images"
if (Test-Path $TmpDir) {
    Write-Host "🧹 Clearing temporary image cache folder at: $TmpDir" -ForegroundColor Yellow
    Remove-Item -Path $TmpDir -Recurse -Force
}

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Green
Write-Host "🎉 TRANSITION TO NATIVE SUPPORT SUCCESSFUL!" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
Write-Host "Antigravity CLI now natively handles media pasting!" -ForegroundColor White
Write-Host "👉 Use  Ctrl + V  to paste clipboard images directly." -ForegroundColor Yellow
Write-Host "👉 Use  Esc       to clear all attached media from the queue." -ForegroundColor Yellow
Write-Host "👉 Use  /clear    to reset your session completely." -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Green
Write-Host ""
