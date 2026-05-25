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

Chạy một dòng lệnh duy nhất để tải về, tự động cài đặt các công cụ cần thiết và thiết lập phím tắt hệ thống:

```bash
curl -sSL https://raw.githubusercontent.com/phuphu0981/PasteImage/main/install.sh | bash
```

---

## 💡 Cách sử dụng

1. **Chụp ảnh màn hình** hoặc **Copy** một hình ảnh bất kỳ vào clipboard.
2. Mở cửa sổ chat **Antigravity CLI** (hoặc bất kỳ trình soạn thảo văn bản nào).
3. Nhấn tổ hợp phím **`Ctrl + Alt + V`**.
4. Ký tự `[Image#1] ` (hoặc số thứ tự tương ứng) sẽ tự động được gõ vào khung chat, đồng thời hiển thị thông báo dán ảnh thành công!

---

## 🧹 Dọn dẹp bộ nhớ tạm

Tất cả ảnh tạm được lưu trữ tại thư mục `/tmp/antigravity_images/` và sẽ tự động được hệ thống Linux dọn dẹp sạch sẽ sau mỗi lần máy tính khởi động lại. Bạn không cần bận tâm về dung lượng lưu trữ của máy.

---

## 📄 Giấy phép
Dự án được phân phối dưới giấy phép MIT.
