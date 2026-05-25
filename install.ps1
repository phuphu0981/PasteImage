# Windows 1-Click Installer for Auto-Paste Image Plugin
# Installs to $env:USERPROFILE\.local\bin and sets up native Windows hotkey (Ctrl+Alt+V)

$BinDir = Join-Path $env:USERPROFILE ".local\bin"
if (-not (Test-Path $BinDir)) {
    New-Item -ItemType Directory -Path $BinDir -Force | Out-Null
}

$ScriptPath = Join-Path $BinDir "auto_paste_img.ps1"
$AhkPath = Join-Path $BinDir "auto_paste_img.ahk"

Write-Host "🔄 Creating auto_paste_img.ps1 script..." -ForegroundColor Cyan

# 1. Generate auto_paste_img.ps1
$ps1Content = @"
# Auto-Paste Image Script for Windows (PowerShell)
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

`$TmpDir = Join-Path `$env:TEMP "antigravity_images"
if (-not (Test-Path `$TmpDir)) {
    New-Item -ItemType Directory -Path `$TmpDir -Force | Out-Null
}

`$TempFile = Join-Path `$TmpDir "current_clip.png"

if ([System.Windows.Forms.Clipboard]::ContainsImage()) {
    `$img = [System.Windows.Forms.Clipboard]::GetImage()
    `$img.Save(`$TempFile, [System.Drawing.Imaging.ImageFormat]::Png)
    `$img.Dispose()
    
    `$MatchedIndex = `$null
    `$MaxIndex = 0
    
    `$files = Get-ChildItem -Path `$TmpDir -Filter "img_*.png"
    foreach (`$file in `$files) {
        if (`$file.Name -match "^img_(\d+)\.png$") {
            `$num = [int]`$Matches[1]
            if (`$num -gt `$MaxIndex) {
                `$MaxIndex = `$num
            }
            
            `$hash1 = Get-FileHash -Path `$TempFile -Algorithm MD5
            `$hash2 = Get-FileHash -Path `$file.FullName -Algorithm MD5
            if (`$hash1.Hash -eq `$hash2.Hash) {
                `$MatchedIndex = `$num
                break
            }
        }
    }
    
    if (`$MatchedIndex -ne `$null) {
        `$Index = `$MatchedIndex
        Remove-Item -Path `$TempFile -Force
    } else {
        `$Index = `$MaxIndex + 1
        `$NewFile = Join-Path `$TmpDir "img_`$Index.png"
        Move-Item -Path `$TempFile -Destination `$NewFile -Force
    }
    
    Start-Sleep -Milliseconds 300
    [System.Windows.Forms.SendKeys]::SendWait("[Image#`$Index] ")
} else {
    [System.Windows.Forms.MessageBox]::Show("No image found in clipboard!", "Image Paste Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    exit 1
}
"@

Set-Content -Path $ScriptPath -Value $ps1Content -Encoding UTF8

Write-Host "🔄 Creating auto_paste_img.ahk template..." -ForegroundColor Cyan

# 2. Generate auto_paste_img.ahk
$ahkContent = @"
#NoEnv
#NoTrayIcon
SendMode Input
SetWorkingDir %A_ScriptDir%

^!v::
Run, powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File "%USERPROFILE%\.local\bin\auto_paste_img.ps1", , Hide
return
"@

Set-Content -Path $AhkPath -Value $ahkContent -Encoding UTF8

Write-Host "🔄 Setting up native Windows hotkey (Ctrl + Alt + V) via Startup shortcut..." -ForegroundColor Cyan

# 3. Create Windows native Startup shortcut (.lnk) with registered hotkey
try {
    $WshShell = New-Object -ComObject WScript.Shell
    $StartupDir = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs\Startup"
    $ShortcutPath = Join-Path $StartupDir "PasteImage.lnk"
    
    $Shortcut = $WshShell.CreateShortcut($ShortcutPath)
    $Shortcut.TargetPath = "powershell.exe"
    $Shortcut.Arguments = "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$ScriptPath`""
    $Shortcut.Hotkey = "Ctrl+Alt+V"
    $Shortcut.WindowStyle = 7 # Minimized/Hidden window
    $Shortcut.Save()
    
    Write-Host ""
    Write-Host "==========================================" -ForegroundColor Green
    Write-Host "✅ WINDOWS INSTALLATION SUCCESSFUL!" -ForegroundColor Green
    Write-Host "🎉 NATIVE HOTKEY REGISTERED: Ctrl + Alt + V" -ForegroundColor Green
    Write-Host "👉 The shortcut has been added to your Windows Startup folder." -ForegroundColor Yellow
    Write-Host "👉 Press Ctrl+Alt+V anywhere to paste and type the clipboard image!" -ForegroundColor Yellow
    Write-Host "==========================================" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Failed to create native Windows shortcut. If you use AutoHotkey, please run the generated: $AhkPath" -ForegroundColor Red
}
