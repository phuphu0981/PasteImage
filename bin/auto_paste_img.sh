#!/bin/bash
# Script to automate pasting clipboard images into Antigravity CLI
# Requirements: xclip, xdotool, libnotify-bin

# Temporary directory to store images
TMP_DIR="/tmp/antigravity_images"
mkdir -p "$TMP_DIR"

# Check required tools
MISSING_TOOLS=""
if ! command -v xclip &> /dev/null; then MISSING_TOOLS="$MISSING_TOOLS xclip"; fi
if ! command -v xdotool &> /dev/null; then MISSING_TOOLS="$MISSING_TOOLS xdotool"; fi
if ! command -v notify-send &> /dev/null; then MISSING_TOOLS="$MISSING_TOOLS libnotify-bin"; fi

if [ "$MISSING_TOOLS" != "" ]; then
    echo "Missing tools:$MISSING_TOOLS. Please run: sudo apt install$MISSING_TOOLS"
    # Notify using notify-send if available, otherwise print to terminal
    command -v notify-send &> /dev/null && notify-send "Image Paste Error" "Missing packages:$MISSING_TOOLS. Please install them!"
    exit 1
fi

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
