# 🌟 Presenta - Next-Generation Template Marketplace

**Presenta** là nền tảng chợ điện tử (marketplace) kết nối sinh viên, học viên học thuật và các nhà thiết kế chuyên nghiệp trong việc mua bán, trao đổi các mẫu thuyết trình (presentation templates), tài liệu số và cung cấp dịch vụ thiết kế tùy chỉnh (custom design services).

---

## 🎯 Tổng Quan Dự Án & Vai Trò (User Roles)

Hệ thống hoạt động theo mô hình phân quyền rõ ràng giữa 3 vai trò:
1. **Khách hàng (Customer)**: Tìm kiếm, lọc và mua sắm các template chất lượng cao. Đánh giá sản phẩm đã mua, đặt hàng thiết kế riêng theo yêu cầu (Book Designer), và thực hiện thanh toán trực tuyến qua cổng VNPay/MoMo.
2. **Nhà thiết kế (Designer)**: Đăng tải sản phẩm template cá nhân lên chợ, quản lý danh sách sản phẩm, nhận các đơn đặt hàng thiết kế riêng (HIRE_DESIGNER), thống kê doanh thu bán hàng và gửi yêu cầu rút tiền về tài khoản ngân hàng.
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

## ⚙️ Thiết Kế Hệ Thống Quan Trọng

### A. Quản lý cấu hình Bảo mật (Mô hình `.env` tự chế)
Để tránh các xung đột thư viện với Java 8, hệ thống không sử dụng thư viện bên thứ ba như `dotenv-java`.
* **Vị trí file cấu hình**: File `.env` chứa mật khẩu kết nối database được đặt trong thư mục `src/main/resources/` (biên dịch trực tiếp vào Classpath `/target/classes/`).
* **Cơ chế đọc**: Lớp [DBUtils](src/main/java/com/util/DBUtils.java) sử dụng luồng đọc native:
  ```java
  ClassLoader.getResourceAsStream(".env")
  ```
* **Tính tương thích Hybrid/Cloud**: Toàn bộ hệ thống kiểm tra biến môi trường hệ thống của Cloud trước (`System.getenv(key)`), nếu chạy local thì mới tự động fallback về file cấu hình `.env` vật lý.

### B. Hỗ trợ Tiếng Việt có dấu (Vietnamese encoding filter)
* **Bộ lọc Encoding**: [EncodingFilter](src/main/java/com/filter/EncodingFilter.java) được cấu hình toàn cục (`/*`) để tự động áp dụng `request.setCharacterEncoding("UTF-8")` và `response.setCharacterEncoding("UTF-8")` cho mọi luồng request/response, tránh hiện tượng lỗi font tiếng Việt khi nhập liệu.
* **Cấu trúc CSDL**: Mọi cột dữ liệu lưu trữ tiếng Việt đều được định nghĩa kiểu dữ liệu `NVARCHAR` trong MS SQL Server.

### C. Luồng thanh toán (Payment Integrations)
Hệ thống tích hợp thành công hai cổng thanh toán Sandbox phổ biến tại Việt Nam:
* **VNPay**: Hỗ trợ chữ ký bảo mật thuật toán `HmacSHA512`.
* **MoMo**: Hỗ trợ phương thức `captureWallet` sử dụng chữ ký `HmacSHA256`.

---

## 📁 Cấu Trúc Thư Mục Dự Án (Project Structure)

```
Presenta/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       ├── controller/    # Lớp Servlet xử lý logic điều hướng
│   │   │       │   ├── admin/     # Quản lý dành cho Quản trị viên
│   │   │       │   ├── designer/  # Quản lý dành cho Nhà thiết kế
│   │   │       │   └── web/       # Chức năng dành cho Khách hàng & Chung
│   │   │       ├── filter/        # Bộ lọc phân quyền (AdminFilter) và Encoding
│   │   │       ├── model/         # Các lớp thực thể (Entity) và truy vấn DAO
│   │   │       └── util/          # Cấu hình kết nối DB và cấu hình thanh toán
│   │   ├── webapp/
│   │   │   ├── assets/            # CSS, JS và hình ảnh tĩnh
│   │   │   ├── WEB-INF/           # File cấu hình web.xml
│   │   │   └── views/             # Giao diện JSP chia theo vai trò người dùng
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
4. Mở tab Query mới, dán toàn bộ mã lệnh trong file [FinaleProduction.sql](FinaleProduction.sql) và nhấn **F5** để khởi chạy tạo bảng và nạp dữ liệu mẫu.

### Bước 2: Cấu hình Môi trường `.env`
1. Tạo thư mục `src/main/resources/` (nếu chưa tồn tại).
2. Tạo file có tên `.env` bên trong thư mục này.
3. Sao chép nội dung từ file `.env.example` vào `.env` mới tạo và điền các thông tin tương ứng:
   ```env
   DB_HOST=localhost -- Hoặc endpoint AWS RDS
   DB_NAME=Presenta
   DB_USER=sa
   DB_PASSWORD=mật_khẩu_của_bạn
   ```

### Bước 3: Build và Chạy ứng dụng
* Sử dụng một IDE hỗ trợ Java Web (như **NetBeans 12+**, **IntelliJ IDEA Ultimate** hoặc **Eclipse**):
  1. Mở dự án Maven từ file `pom.xml`.
  2. Cấu hình Server Apache Tomcat 9.0 tích hợp trong IDE.
  3. Nhấp chuột phải vào dự án -> Chọn **Clean and Build**.
  4. Chọn **Run** để khởi chạy Tomcat server. Trình duyệt sẽ tự động mở trang chủ tại địa chỉ `http://localhost:8080/EXE202_Maven/`.

---
*Chúc bạn có những trải nghiệm phát triển tuyệt vời cùng dự án **Presenta**!* 🚀
