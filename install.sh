#!/bin/bash
# Migration & Cleanup Script for Auto-Paste Image Plugin
# Transitioning to native Antigravity CLI 'Ctrl + V' and 'Esc' support

echo "🔄 Initializing Migration and Cleanup to Native Clipboard..."

# 1. Clean up custom GNOME keyboard shortcut
if command -v gsettings &>/dev/null; then
    KEY_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom-antigravity-paste/"
    
    echo "🔄 Checking for old custom GNOME keybindings..."
    CURRENT_BINDINGS=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings 2>/dev/null)
    
    if [[ "$CURRENT_BINDINGS" == *"$KEY_PATH"* ]]; then
        echo "🧹 Found old custom keybinding. Removing from GNOME settings..."
        
        # Remove the key path from the bindings array
        # e.g., ['/key1/', '/key_to_remove/'] -> ['/key1/']
        NEW_BINDINGS=$(echo "$CURRENT_BINDINGS" | sed "s|'$KEY_PATH', ||g" | sed "s|, '$KEY_PATH'||g" | sed "s|'$KEY_PATH'||g")
        
        # If the resulting array is empty/invalid, reset to default empty array
        if [[ "$NEW_BINDINGS" == "[]" ]] || [[ "$NEW_BINDINGS" == "" ]] || [[ "$NEW_BINDINGS" == "@as []" ]]; then
            NEW_BINDINGS="@as []"
        fi
        
        gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$NEW_BINDINGS"
        
        # Reset the path properties
        gsettings reset-recursively org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$KEY_PATH" 2>/dev/null
        echo "✅ GNOME custom keybinding removed successfully."
    else
        echo "✅ No custom GNOME keybinding found."
    fi
fi

# 2. Remove script files
SCRIPT_PATH="$HOME/.local/bin/auto-paste-img"
if [ -f "$SCRIPT_PATH" ]; then
    echo "🧹 Removing obsolete script file at: $SCRIPT_PATH"
    rm -f "$SCRIPT_PATH"
fi

# 3. Clean up temporary directory
TMP_DIR="/tmp/antigravity_images"
if [ -d "$TMP_DIR" ]; then
    echo "🧹 Clearing temporary image cache folder at: $TMP_DIR"
    rm -rf "$TMP_DIR"
fi

echo ""
echo "=========================================================="
echo "🎉 TRANSITION TO NATIVE SUPPORT SUCCESSFUL!"
echo "=========================================================="
echo "Antigravity CLI now natively handles media pasting!"
echo "👉 Use  Ctrl + V  to paste clipboard images directly."
echo "👉 Use  Esc       to clear all attached media from the queue."
echo "👉 Use  /clear    to reset your session completely."
echo "=========================================================="
echo ""
