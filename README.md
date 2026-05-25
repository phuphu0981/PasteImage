# 🚀 Antigravity CLI Auto-Paste Image Plugin

A lightweight, intelligent tool that automates pasting images from your clipboard directly into **Antigravity CLI** using a single hotkey: `Ctrl + Alt + V`.

It works seamlessly on both **Linux** and **Windows**!

---

## 📋 Minimum Requirements

### 🐧 Linux
* **OS:** Any Linux distribution with X11 display server (or Wayland with Xwayland support).
* **Packages:** `xclip`, `xdotool`, `libnotify` (*automatically installed by the Linux installer*).

### 🪟 Windows
* **OS:** Windows 7 / 10 / 11.
* **PowerShell:** Version 4.0 or newer (*built-in*).
* **.NET Framework:** Version 4.0 or newer (*built-in*).

---

## ✨ Features

* 📸 **Instant Paste:** Automatically saves clipboard images to a temporary directory and types the reference code `[Image#X]` into your active chat window.
* 🧠 **Smart Duplicate Detection:** Compares the binary data/hash of the pasted image with existing ones.
  * If it's a new image: It increments the index (`[Image#1]`, `[Image#2]`, `[Image#3]`, etc.) and stores it.
  * If it's an identical image: It reuses the existing index and deletes the duplicate file to save storage.
* 🎹 **Keyboard Modifier Fix:** Utilizes keyboard state clearing features (`--clearmodifiers` on Linux, native `.NET SendKeys` on Windows) to prevent active modifier keys from eating the leading open bracket `[`.
* 💻 **Multi-Platform Support:** 
  * **Linux:** Compatible with popular distributions (Ubuntu/Debian, Fedora, Arch Linux, and openSUSE).
  * **Windows:** Fully native PowerShell and .NET implementation with **no external dependencies required**!

---

## 📦 1-Click Installation

### 🐧 Linux
Run the following single-line command in your Linux terminal to download, automatically install dependencies, and register the system hotkey:

```bash
curl -sSL https://raw.githubusercontent.com/phuphu0981/PasteImage/main/install.sh | bash
```

### 🪟 Windows
Run the following single-line command in **PowerShell** to download, install the scripts, and natively register the `Ctrl + Alt + V` hotkey:

```powershell
irm https://raw.githubusercontent.com/phuphu0981/PasteImage/main/install.ps1 | iex
```

*(This automatically registers the native Windows hotkey via your Startup folder, requiring no third-party tools!)*

---

## 💡 How to Use

1. **Take a screenshot** or **Copy** any image to your clipboard.
2. Focus on your **Antigravity CLI** chat window (or any text editor).
3. Press the hotkey **`Ctrl + Alt + V`**.
4. The tag `[Image#1]` (or the corresponding index) will automatically be typed into the chat!

---

## 🧹 Auto-Cleanup

All temporary images are stored in your system's temp directory:
* **Linux:** `/tmp/antigravity_images/`
* **Windows:** `%TEMP%\antigravity_images\` (usually `AppData\Local\Temp\antigravity_images`)

These are automatically cleared by the operating system upon reboot, ensuring zero persistent disk space usage.


