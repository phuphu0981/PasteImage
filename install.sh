#!/bin/bash
# Script cài đặt công cụ tự động dán ảnh cho Antigravity CLI (1 Click)

# Tự động nhận diện trình quản lý gói để cài đặt công cụ cần thiết
if command -v apt-get &> /dev/null; then
    echo "🔄 Đang cài đặt các công cụ cần thiết bằng apt-get (có thể yêu cầu mật khẩu sudo)..."
    sudo apt-get update && sudo apt-get install -y xclip xdotool libnotify-bin
elif command -v dnf &> /dev/null; then
    echo "🔄 Đang cài đặt các công cụ cần thiết bằng dnf (có thể yêu cầu mật khẩu sudo)..."
    sudo dnf install -y xclip xdotool libnotify
elif command -v pacman &> /dev/null; then
    echo "🔄 Đang cài đặt các công cụ cần thiết bằng pacman (có thể yêu cầu mật khẩu sudo)..."
    sudo pacman -S --noconfirm xclip xdotool libnotify
elif command -v zypper &> /dev/null; then
    echo "🔄 Đang cài đặt các công cụ cần thiết bằng zypper (có thể yêu cầu mật khẩu sudo)..."
    sudo zypper install -y xclip xdotool libnotify
else
    echo "⚠️ Không tìm thấy trình quản lý gói phổ biến (apt, dnf, pacman, zypper)."
    echo "Vui lòng tự đảm bảo đã cài đặt: xclip, xdotool, libnotify."
fi

echo "🔄 Đang tạo script tự động dán ảnh..."
mkdir -p ~/.local/bin

# Đường dẫn file script sẽ được lưu
SCRIPT_PATH="$HOME/.local/bin/auto-paste-img"

# Tạo nội dung script
cat << 'EOF' > "$SCRIPT_PATH"
#!/bin/bash
TMP_DIR="/tmp/antigravity_images"
mkdir -p "$TMP_DIR"

# Lưu ảnh tạm từ clipboard ra file tạm để kiểm tra
TEMP_FILE="$TMP_DIR/current_clip.png"
xclip -selection clipboard -t image/png -o > "$TEMP_FILE" 2>/dev/null

# Kiểm tra xem ảnh có được lưu thành công không
if [ -s "$TEMP_FILE" ]; then
    MATCHED_INDEX=""
    MAX_INDEX=0
    
    # Duyệt một vòng duy nhất để vừa tìm ảnh trùng lặp vừa xác định Index lớn nhất
    for file in "$TMP_DIR"/img_*.png; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            if [[ "$filename" =~ ^img_([0-9]+)\.png$ ]]; then
                num="${BASH_REMATCH[1]}"
                
                # Cập nhật số Index lớn nhất hiện tại
                if [ "$num" -gt "$MAX_INDEX" ]; then
                    MAX_INDEX="$num"
                fi
                
                # So sánh dữ liệu nhị phân xem ảnh có trùng khớp không
                if cmp -s "$TEMP_FILE" "$file"; then
                    MATCHED_INDEX="$num"
                    break # Tìm thấy trùng khớp, thoát sớm
                fi
            fi
        fi
    done
    
    if [ -n "$MATCHED_INDEX" ]; then
        # Nếu trùng ảnh đã có, tái sử dụng INDEX của ảnh đó và xóa file tạm
        INDEX="$MATCHED_INDEX"
        rm -f "$TEMP_FILE"
    else
        # Nếu là ảnh mới, INDEX sẽ là số lớn nhất hiện tại cộng thêm 1
        INDEX=$((MAX_INDEX + 1))
        # Đổi tên file tạm thành file ảnh mới với INDEX mới
        mv "$TEMP_FILE" "$TMP_DIR/img_$INDEX.png"
    fi
    
    # Nhả phím nếu người dùng đang giữ phím tắt (để tránh xung đột với xdotool)
    sleep 0.3
    
    # Dùng xdotool để tự động gõ [Image#Index] vào cửa sổ hiện tại (dọn dẹp các phím modifier)
    xdotool type --clearmodifiers "[Image#$INDEX] "
    
    # Hiển thị thông báo nhỏ trên màn hình
    notify-send "Đã dán ảnh" "Đường dẫn: $TMP_DIR/img_$INDEX.png"
else
    # Xóa file rác nếu clipboard không chứa ảnh
    rm -f "$TEMP_FILE"
    notify-send "Lỗi Paste Ảnh" "Không có hình ảnh nào trong clipboard!"
    exit 1
fi
EOF

# Cấp quyền thực thi
chmod +x "$SCRIPT_PATH"

echo "🔄 Đang thiết lập phím tắt Ctrl+Alt+V cho Ubuntu..."
if command -v gsettings &> /dev/null; then
    KEY_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom-antigravity-paste/"
    
    # Lấy mảng phím tắt hiện tại
    CURRENT_BINDINGS=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)
    
    if [[ "$CURRENT_BINDINGS" == "@as []" ]] || [[ -z "$CURRENT_BINDINGS" ]]; then
        CURRENT_BINDINGS="['$KEY_PATH']"
    elif [[ "$CURRENT_BINDINGS" != *"$KEY_PATH"* ]]; then
        # Thêm phím tắt mới vào cuối mảng
        CURRENT_BINDINGS="${CURRENT_BINDINGS%]*}, '$KEY_PATH']"
    fi
    
    # Cập nhật danh sách phím tắt
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$CURRENT_BINDINGS"
    
    # Cấu hình chi tiết phím tắt
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$KEY_PATH" name "Paste Image Antigravity"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$KEY_PATH" command "$SCRIPT_PATH"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$KEY_PATH" binding "<Primary><Alt>v"
    
    echo ""
    echo "=========================================="
    echo "✅ CÀI ĐẶT THÀNH CÔNG!"
    echo "🎉 TỪ GIỜ TRỞ ĐI: Mỗi khi mở Antigravity CLI, bạn chỉ cần bấm tổ hợp phím:"
    echo "👉  Ctrl + Alt + V  👈"
    echo "Ảnh từ clipboard sẽ được tự động lưu và gõ sẵn đường dẫn vào khung chat cho bạn!"
    echo "=========================================="
else
    echo "✅ Cài đặt script hoàn tất tại: $SCRIPT_PATH"
    echo "⚠️ Hệ thống không sử dụng môi trường GNOME chuẩn. Bạn cần tự vào Cài đặt hệ điều hành (Keyboard Shortcuts) và gán phím tắt tùy chọn cho lệnh: $SCRIPT_PATH"
fi
