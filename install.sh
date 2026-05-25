#!/bin/bash
# Installation script for the Auto-Paste Image Plugin for Antigravity CLI (1-Click)

# Automatically detect the package manager to install required tools
if command -v apt-get &> /dev/null; then
    echo "🔄 Installing required tools using apt-get (sudo password may be required)..."
    sudo apt-get update && sudo apt-get install -y xclip xdotool libnotify-bin
elif command -v dnf &> /dev/null; then
    echo "🔄 Installing required tools using dnf (sudo password may be required)..."
    sudo dnf install -y xclip xdotool libnotify
elif command -v pacman &> /dev/null; then
    echo "🔄 Installing required tools using pacman (sudo password may be required)..."
    sudo pacman -S --noconfirm xclip xdotool libnotify
elif command -v zypper &> /dev/null; then
    echo "🔄 Installing required tools using zypper (sudo password may be required)..."
    sudo zypper install -y xclip xdotool libnotify
else
    echo "⚠️ No supported package manager found (apt, dnf, pacman, zypper)."
    echo "Please manually ensure the following dependencies are installed: xclip, xdotool, libnotify."
fi

echo "🔄 Generating auto-paste script..."
mkdir -p ~/.local/bin

# Path where the script will be saved
SCRIPT_PATH="$HOME/.local/bin/auto-paste-img"

# Generate script content
cat << 'EOF' > "$SCRIPT_PATH"
#!/bin/bash
# Script to automate pasting clipboard images into Antigravity CLI
# Requirements: xclip, xdotool, libnotify-bin

# Temporary directory to store images
TMP_DIR="/tmp/antigravity_images"
mkdir -p "$TMP_DIR"

# Save clipboard image to a temporary file for verification
TEMP_FILE="$TMP_DIR/current_clip.png"
xclip -selection clipboard -t image/png -o > "$TEMP_FILE" 2>/dev/null

# Verify if the image was successfully saved
if [ -s "$TEMP_FILE" ]; then
    MATCHED_INDEX=""
    MAX_INDEX=0
    
    # Iterate in a single pass to check for duplicate images and calculate maximum index
    for file in "$TMP_DIR"/img_*.png; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            if [[ "$filename" =~ ^img_([0-9]+)\.png$ ]]; then
                num="${BASH_REMATCH[1]}"
                
                # Update current maximum index
                if [ "$num" -gt "$MAX_INDEX" ]; then
                    MAX_INDEX="$num"
                fi
                
                # Perform binary comparison to check if the image is identical
                if cmp -s "$TEMP_FILE" "$file"; then
                    MATCHED_INDEX="$num"
                    break # Identical image found, exit early
                fi
            fi
        fi
    done
    
    if [ -n "$MATCHED_INDEX" ]; then
        # If a duplicate image is found, reuse its index and delete the temporary file
        INDEX="$MATCHED_INDEX"
        rm -f "$TEMP_FILE"
    else
        # If it is a new image, increment the maximum index by 1
        INDEX=$((MAX_INDEX + 1))
        # Rename the temporary file to save it with the new index
        mv "$TEMP_FILE" "$TMP_DIR/img_$INDEX.png"
    fi
    
    # Release modifier keys if held down to prevent conflicts with xdotool
    sleep 0.3
    
    # Use xdotool to type [Image#Index] into the active window (clearing modifiers)
    xdotool type --clearmodifiers "[Image#$INDEX] "
    
    # Display desktop notification
    notify-send "Image Pasted" "Saved to: $TMP_DIR/img_$INDEX.png"
else
    # Clean up temporary file if clipboard does not contain an image
    rm -f "$TEMP_FILE"
    notify-send "Image Paste Error" "No image found in clipboard!"
    exit 1
fi
EOF

# Make the script executable
chmod +x "$SCRIPT_PATH"

echo "🔄 Registering system hotkey Ctrl+Alt+V for GNOME..."
if command -v gsettings &> /dev/null; then
    KEY_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom-antigravity-paste/"
    
    # Get current custom keybindings
    CURRENT_BINDINGS=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)
    
    if [[ "$CURRENT_BINDINGS" == "@as []" ]] || [[ -z "$CURRENT_BINDINGS" ]]; then
        CURRENT_BINDINGS="['$KEY_PATH']"
    elif [[ "$CURRENT_BINDINGS" != *"$KEY_PATH"* ]]; then
        # Append new keybinding to the array
        CURRENT_BINDINGS="${CURRENT_BINDINGS%]*}, '$KEY_PATH']"
    fi
    
    # Update custom keybindings list
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$CURRENT_BINDINGS"
    
    # Configure detailed keybinding properties
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$KEY_PATH" name "Paste Image Antigravity"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$KEY_PATH" command "$SCRIPT_PATH"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$KEY_PATH" binding "<Primary><Alt>v"
    
    echo ""
    echo "=========================================="
    echo "✅ INSTALLATION SUCCESSFUL!"
    echo "🎉 FROM NOW ON: Whenever you use Antigravity CLI, just press the hotkey:"
    echo "👉  Ctrl + Alt + V  👈"
    echo "The image from your clipboard will be automatically saved and its tag typed into the chat!"
    echo "=========================================="
else
    echo "✅ Script installation completed at: $SCRIPT_PATH"
    echo "⚠️ Standard GNOME environment not detected. Please manually go to your system settings (Keyboard Shortcuts) and assign a hotkey for: $SCRIPT_PATH"
fi
