# 🚀 Antigravity CLI Auto-Paste Image Plugin

Một công cụ siêu nhẹ, thông minh giúp tự động hóa việc dán ảnh từ clipboard thẳng vào **Antigravity CLI** bằng phím tắt `Ctrl + Alt + V` duy nhất.

---

## ✨ Tính năng nổi bật

* 📸 **Dán ảnh siêu tốc:** Tự động lưu ảnh từ clipboard vào thư mục tạm và gõ mã tham chiếu `[Image#X]` vào khung chat.
* 🧠 **Nhận diện ảnh thông minh (Tránh trùng lặp):** So sánh dữ liệu nhị phân của ảnh để phát hiện trùng lặp.
  * Nếu dán ảnh mới: Tự động tăng số thứ tự (`[Image#1]`, `[Image#2]`, `[Image#3]`,...).
  * Nếu dán lại ảnh cũ: Tự động dùng lại Index cũ mà không sinh file rác.
* 🎹 **Khắc phục lỗi bàn phím (xdotool):** Tích hợp tính năng tự động giải phóng phím bổ trợ (`--clearmodifiers`) giúp tránh bị nuốt phím mở ngoặc `[`.
* 🐧 **Hỗ trợ đa nền tảng:** Tự động tương thích với các bản phân phối Linux phổ biến (Ubuntu/Debian, Fedora, Arch, openSUSE).

---

## 📦 Hướng dẫn cài đặt nhanh (1-Click Install)

Chỉ cần chạy một dòng lệnh duy nhất để tải về, cài đặt dependencies và cấu hình phím tắt hệ thống tự động:

### Cách 1: Cài đặt trực tiếp từ Git (Khuyên dùng)
```bash
curl -sSL https://raw.githubusercontent.com/<YOUR_GITHUB_USERNAME>/<REPO_NAME>/main/install.sh | bash
```

### Cách 2: Clone repository và cài đặt thủ công
```bash
git clone https://github.com/<YOUR_GITHUB_USERNAME>/<REPO_NAME>.git antiImg
cd antiImg
chmod +x install.sh
./install.sh
```

*(Lưu ý: Thay thế `<YOUR_GITHUB_USERNAME>` và `<REPO_NAME>` bằng thông tin tài khoản GitHub và tên repository của bạn).*

---

## 🛠️ Hướng dẫn đẩy lên Git (Push to Git)

Để biến công cụ này thành một plugin tải được bằng dòng lệnh, bạn hãy tạo một repository mới trên GitHub (ví dụ: `antiImg`) và chạy các lệnh sau trong thư mục dự án hiện tại của bạn:

```bash
# Khởi tạo Git
git init

# Thêm tất cả các file
git add .

# Commit phiên bản tối ưu
git commit -m "feat: optimize auto paste image plugin with duplicate detection and multi-distro installer"

# Thiết lập nhánh chính
git branch -M main

# Thêm đường dẫn tới Github của bạn
git remote add origin https://github.com/<YOUR_GITHUB_USERNAME>/<REPO_NAME>.git

# Đẩy mã nguồn lên Github
git push -u origin main
```

---

## 💡 Cách sử dụng

1. **Chụp ảnh màn hình** hoặc **Copy** một hình ảnh bất kỳ vào clipboard.
2. Mở cửa sổ chat **Antigravity CLI** (hoặc bất kỳ trình soạn thảo văn bản nào).
3. Nhấn tổ hợp phím **`Ctrl + Alt + V`**.
4. Đường dẫn ảnh dạng `[Image#1] ` sẽ tự động được gõ vào khung chat, đồng thời xuất hiện thông báo nhỏ (notify-send) báo dán ảnh thành công!

---

## 🧹 Dọn dẹp bộ nhớ tạm

Tất cả ảnh tạm được lưu trữ tại `/tmp/antigravity_images/` và sẽ tự động được hệ thống Linux dọn dẹp sạch sẽ sau mỗi lần máy tính khởi động lại (Reboot). Bạn không cần lo lắng về dung lượng đĩa!

---

## 📄 Giấy phép
Dự án được phân phối dưới giấy phép MIT. Tự do sử dụng và tùy biến!
