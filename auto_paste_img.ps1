# Auto-Paste Image Script for Windows (PowerShell)
# Requirements: PowerShell 4.0+, .NET Framework (Pre-installed on Windows)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Temporary directory for images
$TmpDir = Join-Path $env:TEMP "antigravity_images"
if (-not (Test-Path $TmpDir)) {
    New-Item -ItemType Directory -Path $TmpDir -Force | Out-Null
}

$TempFile = Join-Path $TmpDir "current_clip.png"

# Check if clipboard has an image
if ([System.Windows.Forms.Clipboard]::ContainsImage()) {
    $img = [System.Windows.Forms.Clipboard]::GetImage()
    $img.Save($TempFile, [System.Drawing.Imaging.ImageFormat]::Png)
    $img.Dispose()
    
    $MatchedIndex = $null
    $MaxIndex = 0
    
    # 1. Compare with existing files for duplicates and find max index
    $files = Get-ChildItem -Path $TmpDir -Filter "img_*.png"
    foreach ($file in $files) {
        if ($file.Name -match "^img_(\d+)\.png$") {
            $num = [int]$Matches[1]
            if ($num -gt $MaxIndex) {
                $MaxIndex = $num
            }
            
            # Check if files are identical using file hash (MD5)
            $hash1 = Get-FileHash -Path $TempFile -Algorithm MD5
            $hash2 = Get-FileHash -Path $file.FullName -Algorithm MD5
            if ($hash1.Hash -eq $hash2.Hash) {
                $MatchedIndex = $num
                break
            }
        }
    }
    
    # 2. Determine index and rename/delete temp file
    if ($MatchedIndex -ne $null) {
        $Index = $MatchedIndex
        Remove-Item -Path $TempFile -Force
    } else {
        $Index = $MaxIndex + 1
        $NewFile = Join-Path $TmpDir "img_$Index.png"
        Move-Item -Path $TempFile -Destination $NewFile -Force
    }
    
    # Release modifier keys and wait for keyboard stability
    Start-Sleep -Milliseconds 300
    
    # Type the reference code into the active window
    [System.Windows.Forms.SendKeys]::SendWait("[Image#$Index] ")
    
} else {
    # If no image is in the clipboard, display a message
    [System.Windows.Forms.MessageBox]::Show("No image found in clipboard!", "Image Paste Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    exit 1
}
