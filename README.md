# 🚀 Antigravity CLI Native Clipboard Image Support

Now natively built directly into **Antigravity CLI**! You no longer need external scripts, keyloggers, background listeners, or third-party packages to paste and clear images.

Everything is streamlined, fast, and fully integrated out-of-the-box.

---

## ✨ Features & Benefits

* ⚡ **Zero Dependencies:** No need to install `xclip`, `xdotool`, `AutoHotkey`, or configure startup shortcut files.
* 📸 **Native Paste:** Press `Ctrl + V` inside the Antigravity CLI terminal, and the active clipboard image is immediately captured and attached.
* 🧹 **Single-Key Clear:** Press `Esc` once or twice to clean up and remove all attached media from the composer queue in an instant.
* 🔒 **Zero Background Processes:** Saves CPU resources and prevents keybinding conflicts on your OS.

---

## 🎹 Keyboard Commands & Workflows

| Command | Action / Keyboard Shortcut | Behavior in Composer |
| :--- | :--- | :--- |
| **Paste Image** | `Ctrl + V` | Direct and instant attachment of clipboard image to the prompt. |
| **Clear All Attachments** | `Esc` | Instantly removes all currently queued/collapsed media from the unsent prompt. |
| **Start Fresh Conversation** | `/clear` | Resets the conversation, history, and clears all previous attachment context. |
| **Roll Back Steps** | `/rewind` or `Esc` (twice) | Reverts conversation state and clears associated media from previous turns. |

---

## 🧹 Old Plugin Migration & Cleanup

If you installed the older version of the custom `Ctrl + Alt + V` hotkey script, you should run the cleanup script to remove obsolete background services, custom GNOME keybindings, or Windows startup items to prevent key conflicts.

### 🐧 Linux (GNOME / Terminal)
Run the following command to completely clean up custom scripts and restore native OS hotkeys:
```bash
curl -sSL https://raw.githubusercontent.com/phuphu0981/PasteImage/main/install.sh | bash
```
*(Or manually run the updated `./install.sh` from the repository).*

### 🪟 Windows (PowerShell)
Run the following command in **PowerShell** to clean up startup shortcuts and folders:
```powershell
irm https://raw.githubusercontent.com/phuphu0981/PasteImage/main/install.ps1 | iex
```
*(Or manually run the updated `./install.ps1` from the repository).*

---

## 💡 Quick Tips for Media Management

> [!NOTE]
> **Selective Attachment:** 
> Since `Esc` clears all attachments from the queue at once, if you want to selectively keep only one of multiple images, simply press `Esc` to clear the queue, then copy the single correct image and press `Ctrl + V` again.

> [!TIP]
> **View Active Queue:**
> You can click or view the **`▼ Media(s) attached`** dropdown above the prompt input to inspect what files will be sent to the Gemini model before pressing Enter.
