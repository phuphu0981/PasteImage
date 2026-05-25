# 🚀 Antigravity CLI Auto-Paste Image Plugin

A lightweight, intelligent tool that automates pasting images from your clipboard directly into **Antigravity CLI** using a single hotkey: `Ctrl + Alt + V`.

---

## ✨ Features

* 📸 **Instant Paste:** Automatically saves clipboard images to a temporary directory and types the reference code `[Image#X]` into your chat.
* 🧠 **Smart Duplicate Detection:** Compares the binary data of the pasted image with existing ones.
  * If it's a new image: It increments the index (`[Image#1]`, `[Image#2]`, `[Image#3]`, etc.) and stores it.
  * If it's an identical image: It reuses the existing index and deletes the duplicate file to save storage.
* 🎹 **Keyboard Modifier Fix:** Utilizes `xdotool`'s `--clearmodifiers` flag to prevent active system modifier keys from eating the leading open bracket `[`.
* 🐧 **Multi-Distro Support:** Out-of-the-box compatibility with popular Linux distributions (Ubuntu/Debian, Fedora, Arch Linux, and openSUSE).

---

## 📦 1-Click Installation

Run the following single-line command in your terminal to download, automatically install dependencies, and register the system shortcut:

```bash
curl -sSL https://raw.githubusercontent.com/phuphu0981/PasteImage/main/install.sh | bash
```

---

## 💡 How to Use

1. **Take a screenshot** or **Copy** any image to your clipboard.
2. Focus on your **Antigravity CLI** chat window (or any text editor).
3. Press the hotkey **`Ctrl + Alt + V`**.
4. The tag `[Image#1]` (or the corresponding index) will automatically be typed into the chat, accompanied by a desktop notification!

---

## 🧹 Auto-Cleanup

All temporary images are stored in `/tmp/antigravity_images/`. They are automatically cleared by the Linux system upon reboot, ensuring zero persistent disk space usage.

---

## 📄 License
This project is licensed under the MIT License.
