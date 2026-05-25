#!/bin/bash
# Script to paste an image from the clipboard to a file

# Check if xclip is installed
if ! command -v xclip &> /dev/null; then
    echo "xclip is not installed. Please install it using: sudo apt install xclip"
    exit 1
fi

# Define the filename with a timestamp
FILENAME="img_$(date +%Y%m%d_%H%M%S).png"

# Save the clipboard content as a PNG image
xclip -selection clipboard -t image/png -o > "$FILENAME" 2>/dev/null

# Verify if the image was successfully saved
if [ -s "$FILENAME" ]; then
    echo "✅ Image successfully saved to: $FILENAME"
else
    echo "❌ No image found in clipboard or failed to save."
    rm -f "$FILENAME"
    exit 1
fi
