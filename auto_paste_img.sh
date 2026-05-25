#!/bin/bash
# Script tự động hóa việc dán đường dẫn ảnh vào Antigravity CLI
# Yêu cầu cài đặt: xclip, xdotool, libnotify-bin

# Thư mục lưu ảnh tạm thời (bạn có thể dọn dẹp thư mục này sau này)
TMP_DIR="/tmp/antigravity_images"
mkdir -p "$TMP_DIR"

# Kiểm tra các công cụ cần thiết
MISSING_TOOLS=""
if ! command -v xclip &> /dev/null; then MISSING_TOOLS="$MISSING_TOOLS xclip"; fi
if ! command -v xdotool &> /dev/null; then MISSING_TOOLS="$MISSING_TOOLS xdotool"; fi
if ! command -v notify-send &> /dev/null; then MISSING_TOOLS="$MISSING_TOOLS libnotify-bin"; fi

if [ "$MISSING_TOOLS" != "" ]; then
    echo "Thiếu các công cụ:$MISSING_TOOLS. Vui lòng chạy lệnh: sudo apt install$MISSING_TOOLS"
    # Nếu có notify-send thì thông báo, nếu không thì in ra terminal
    command -v notify-send &> /dev/null && notify-send "Lỗi Paste Ảnh" "Thiếu gói:$MISSING_TOOLS. Cần cài đặt!"
    exit 1
fi

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
