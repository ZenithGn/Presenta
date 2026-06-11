# 🌟 Presenta - Next-Generation Template Marketplace

**Presenta** là nền tảng chợ điện tử (marketplace) kết nối sinh viên, học viên học thuật và các nhà thiết kế chuyên nghiệp trong việc mua bán, trao đổi các mẫu thuyết trình (presentation templates), tài liệu số và cung cấp dịch vụ thiết kế tùy chỉnh (custom design services).

---

## 🎯 Tổng Quan Dự Án & Vai Trò (User Roles)

Hệ thống hoạt động theo mô hình phân quyền rõ ràng giữa 3 vai trò:
1. **Khách hàng (Customer)**: Tìm kiếm, lọc và mua sắm các template chất lượng cao. Đánh giá sản phẩm đã mua, đặt hàng thiết kế riêng theo yêu cầu (Book Designer), và thực hiện thanh toán trực tuyến qua cổng VNPay/MoMo/PayOS.
2. **Nhà thiết kế (Designer)**: Đăng tải sản phẩm template cá nhân lên chợ (tích hợp Cloudinary lưu trữ file tĩnh), quản lý danh sách sản phẩm, nhận các đơn đặt hàng thiết kế riêng (HIRE_DESIGNER), thống kê doanh thu bán hàng và gửi yêu cầu rút tiền về tài khoản ngân hàng.
3. **Quản trị viên (Admin)**: Quản lý tổng thể hệ thống, thống kê doanh thu & biểu đồ phát triển qua Dashboard (Chart.js), phê duyệt các yêu cầu rút tiền của Designer, ban/unban người dùng vi phạm và quản lý phê duyệt template mới.

---

## 🛠️ Công Nghệ & Ràng Buộc Kỹ Thuật (Tech Stack)

* **Ngôn ngữ lập trình**: Java 8 (Phiên bản biên dịch tương thích Class file 52.0).
* **Kiến trúc ứng dụng**: MVC2 (Model-View-Controller) thuần túy trên nền tảng **Servlet & JSP**.
* **Định tuyến (Routing)**: `MainController` đóng vai trò Front Controller tiếp nhận toàn bộ các request qua tham số `action` và chuyển hướng tới các Controller con.
* **Hệ quản trị CSDL**: Microsoft SQL Server (Lưu trữ trên AWS RDS).
* **Công cụ xây dựng & Quản lý thư viện**: Maven.
* **Máy chủ ứng dụng**: Apache Tomcat 9.0.
* **Môi trường Deploy**: Docker containerization chạy trên nền tảng Cloud Render.

---

## ⚙️ Các Tính Năng Kỹ Thuật Nâng Cao

Dự án tích hợp nhiều công nghệ hiện đại để đảm bảo hiệu năng và tính mở rộng:

### A. Lưu trữ File Tĩnh với Cloudinary
* Toàn bộ hình ảnh Avatar và file PDF Portfolio của người dùng được upload trực tiếp lên **Cloudinary** thông qua SDK `cloudinary-http44`.
* Đảm bảo tính sẵn sàng cao, tối ưu hoá dung lượng ảnh (`.webp`) và giảm tải cho máy chủ web.

### B. Gửi Email thông qua Brevo HTTP API
* Thay vì sử dụng SMTP truyền thống (thường bị các nền tảng như Render chặn cổng 587/465), hệ thống sử dụng **Brevo API qua cổng HTTPS (443)**.
* Đảm bảo gửi email khôi phục mật khẩu (kèm mã OTP 6 số) nhanh chóng, không bị liệt vào danh sách thư rác, và không bị Cloud block port.
* Mã OTP bảo mật tự động hết hạn, quản lý vòng đời an toàn qua `HttpSession`.

### C. WebSockets & Real-time Notifications
* Ứng dụng tích hợp `javax.websocket-api` để duy trì kết nối hai chiều theo thời gian thực (Real-time).
* Client lắng nghe qua `ws://` và nhận các thông báo hệ thống (như khi có sự kiện mới, cảnh báo) hiển thị dưới dạng **Toast Notifications** một cách liền mạch mà không cần tải lại trang.

### D. Tác Vụ Chạy Ngầm (Task Scheduler)
* Một **Background Task Scheduler** được khởi tạo thông qua `ServletContextListener` khi Tomcat khởi động.
* Tự động chạy định kỳ (mỗi phút) để:
  1. Xoá bộ nhớ đệm dư thừa (Cache Cleanup) để ngăn ngừa rò rỉ bộ nhớ (Memory Leaks).
  2. Tự động quét và vô hiệu hoá các Mã giảm giá (Vouchers) đã hết hạn trong Cơ sở dữ liệu.

### E. Redis Caching & Bộ nhớ dự phòng
* Ứng dụng dùng thư viện `Jedis` kết nối với Redis để lưu trữ Cache.
* Hệ thống được thiết kế với cơ chế Fallback an toàn: Nếu máy chủ Redis sập hoặc không khả dụng, ứng dụng tự động chuyển sang lưu trữ bộ nhớ đệm cục bộ (Local `ConcurrentHashMap`), đảm bảo không bao giờ bị gián đoạn dịch vụ.

### F. Luồng Thanh Toán (Payment Integrations)
Hệ thống tích hợp thành công các cổng thanh toán phổ biến:
* **VNPay**: Hỗ trợ chữ ký bảo mật thuật toán `HmacSHA512`.
* **MoMo**: Hỗ trợ phương thức `captureWallet` sử dụng chữ ký `HmacSHA256`.
* **PayOS**: Cổng thanh toán chuyển khoản thông minh tự động xác nhận.

---

## 📁 Cấu Trúc Thư Mục Dự Án (Project Structure)

```
Presenta/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       ├── controller/    # Lớp Servlet xử lý logic điều hướng
│   │   │       ├── filter/        # Bộ lọc phân quyền (JWT/Auth) và Encoding
│   │   │       ├── listener/      # Lắng nghe vòng đời ứng dụng (Task Scheduler)
│   │   │       ├── model/         # Các lớp thực thể (Entity) và truy vấn DAO
│   │   │       ├── util/          # Cấu hình DB, Email, Redis, Cloudinary
│   │   │       └── websocket/     # Lớp endpoint cho Real-time Notifications
│   │   ├── webapp/
│   │   │   ├── assets/            # CSS, JS và hình ảnh tĩnh
│   │   │   ├── WEB-INF/           # File cấu hình web.xml
│   │   │   └── views/             # Giao diện JSP chia theo vai trò
│   │   └── resources/             # Nơi chứa file .env bảo mật (local)
├── FinaleProduction.sql           # Script SQL tạo bảng và nạp mock data
├── pom.xml                        # Cấu hình dependencies Maven
└── README.md                      # File tài liệu hướng dẫn này
```

---

## 🚀 Hướng Dẫn Thiết Lập & Khởi Chạy Local

### Bước 1: Khởi tạo Cơ sở dữ liệu
1. Mở SQL Server Management Studio (SSMS) hoặc Azure Data Studio.
2. Kết nối tới server SQL Server của bạn.
3. Tạo mới database có tên là `Presenta`.
4. Mở tab Query mới, dán toàn bộ mã lệnh trong file `FinaleProduction.sql` và nhấn **F5** để khởi chạy tạo bảng và nạp dữ liệu mẫu.

### Bước 2: Cấu hình Môi trường `.env`
1. Tạo file có tên `.env` bên trong thư mục `src/main/resources/`.
2. Sao chép nội dung từ file `.env.example` vào `.env` mới tạo và điền các thông tin (Database, Cloudinary URL, Brevo API Key, Payment Keys).

### Bước 3: Build và Chạy ứng dụng
* Sử dụng một IDE hỗ trợ Java Web (như **NetBeans 12+**, **IntelliJ IDEA Ultimate** hoặc **Eclipse**):
  1. Mở dự án Maven từ file `pom.xml`.
  2. Chuột phải vào dự án -> Chọn **Clean and Build** để tải các package dependencies.
  3. Chọn **Run** để khởi chạy Tomcat server. Trình duyệt sẽ tự động mở trang chủ tại địa chỉ `http://localhost:8080/EXE202_Maven/`.

---
*Được thiết kế cho hiệu năng và tối ưu hóa trải nghiệm người dùng!* 🚀
