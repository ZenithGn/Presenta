-- ===========================================================================
-- SCRIPT HOÀN CHỈNH: TỰ ĐỘNG KHỞI TẠO CẤU TRÚC BẢNG & ĐỔ FULL MOCK DATA
-- Hướng dẫn: Mở SSMS kết nối vào AWS RDS, nhấp chuột phải vào database 'Presenta' 
-- của bạn, chọn 'New Query', dán toàn bộ script này và bấm F5 để chạy.
-- Mật khẩu đăng nhập cho tất cả các tài khoản test bên dưới là: 123
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- PHẦN 1: DỌN DẸP HỆ THỐNG (Xóa bảng cũ theo đúng thứ tự để không lỗi khóa ngoại)
-- ---------------------------------------------------------------------------
IF OBJECT_ID('dbo.Withdrawals', 'U') IS NOT NULL DROP TABLE dbo.Withdrawals;
IF OBJECT_ID('dbo.Reviews', 'U') IS NOT NULL DROP TABLE dbo.Reviews;
IF OBJECT_ID('dbo.Payments', 'U') IS NOT NULL DROP TABLE dbo.Payments;
IF OBJECT_ID('dbo.OrderDetails', 'U') IS NOT NULL DROP TABLE dbo.OrderDetails;
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.Vouchers', 'U') IS NOT NULL DROP TABLE dbo.Vouchers;
IF OBJECT_ID('dbo.Templates', 'U') IS NOT NULL DROP TABLE dbo.Templates;
IF OBJECT_ID('dbo.Categories', 'U') IS NOT NULL DROP TABLE dbo.Categories;
IF OBJECT_ID('dbo.Designer_Profiles', 'U') IS NOT NULL DROP TABLE dbo.Designer_Profiles;
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE dbo.Users;
IF OBJECT_ID('dbo.Roles', 'U') IS NOT NULL DROP TABLE dbo.Roles;

-- ---------------------------------------------------------------------------
-- PHẦN 2: ĐỊNH NGHĨA CẤU TRÚC CƠ SỞ DỮ LIỆU (DDL)
-- ---------------------------------------------------------------------------

-- 1. Tạo bảng Roles (Phân quyền)
CREATE TABLE Roles (
    roleID INT PRIMARY KEY,
    roleName NVARCHAR(50) NOT NULL
);

-- 2. Tạo bảng Users (Tài khoản người dùng hệ thống)
CREATE TABLE Users (
    userID INT IDENTITY(1,1) PRIMARY KEY,
    userName NVARCHAR(50) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL, 
    email NVARCHAR(100) NOT NULL UNIQUE,
    roleID INT,
    status BIT DEFAULT 1, -- 1 là Active, 0 là Banned
    avatarURL NVARCHAR(255) NULL,
    FOREIGN KEY (roleID) REFERENCES Roles(roleID)
);

-- 3. Tạo bảng Designer_Profiles (Thông tin chi tiết của nhà thiết kế)
CREATE TABLE Designer_Profiles (
    profileID INT IDENTITY(1,1) PRIMARY KEY,
    userID INT UNIQUE, 
    bio NVARCHAR(MAX),
    phone NVARCHAR(20) NOT NULL, 
    porfolioURL NVARCHAR(255), 
    avatarURL NVARCHAR(255) NULL,
    balance DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (userID) REFERENCES Users(userID)
);

-- 4. Tạo bảng Categories (Danh mục phân loại sản phẩm)
CREATE TABLE Categories (
    categoryID INT IDENTITY(1,1) PRIMARY KEY,
    categoryName NVARCHAR(100) NOT NULL,
    description NVARCHAR(255)
);

-- 5. Tạo bảng Templates (Kho lưu trữ các mẫu thiết kế)
CREATE TABLE Templates (
    templateID INT IDENTITY(1,1) PRIMARY KEY,
    designerID INT,
    categoryID INT, 
    title NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    price DECIMAL(10, 2) NOT NULL,
    thumbnailURL NVARCHAR(255), 
    fileURL NVARCHAR(255), 
    createAt DATETIME DEFAULT GETDATE(), 
    coreFeatures NVARCHAR(MAX) NULL,
    designAssets NVARCHAR(MAX) NULL,
    FOREIGN KEY (designerID) REFERENCES Users(userID),
    FOREIGN KEY (categoryID) REFERENCES Categories(categoryID)
);

-- 6. Tạo bảng Vouchers (Chương trình mã giảm giá)
CREATE TABLE Vouchers (
    voucherID INT IDENTITY(1,1) PRIMARY KEY,
    code NVARCHAR(50) NOT NULL UNIQUE,
    discountPercent DECIMAL(5,2), 
    maxDiscountAmount DECIMAL(10,2), 
    usageLimit INT, 
    usedCount INT DEFAULT 0, 
    validFrom DATETIME,
    validTo DATETIME,
    status BIT DEFAULT 1 
);

-- 7. Tạo bảng Orders (Hóa đơn tổng)
CREATE TABLE Orders (
    orderID INT IDENTITY(1,1) PRIMARY KEY,
    customerID INT,
    voucherID INT NULL, 
    orderType NVARCHAR(50) NOT NULL, -- 'BUY_TEMPLATE' hoặc 'HIRE_DESIGNER'
    designerID INT NULL, 
    totalPrice DECIMAL(10, 2) NOT NULL, 
    status NVARCHAR(50) DEFAULT 'Pending', -- 'Pending', 'Completed', 'Cancelled'
    createAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (customerID) REFERENCES Users(userID),
    FOREIGN KEY (voucherID) REFERENCES Vouchers(voucherID),
    FOREIGN KEY (designerID) REFERENCES Users(userID)
);

-- 8. Tạo bảng OrderDetails (Chi tiết sản phẩm thuộc hóa đơn)
CREATE TABLE OrderDetails (
    orderDetailID INT IDENTITY(1,1) PRIMARY KEY,
    orderID INT,
    templateID INT NULL, 
    price DECIMAL(10,2) NOT NULL, 
    FOREIGN KEY (orderID) REFERENCES Orders(orderID),
    FOREIGN KEY (templateID) REFERENCES Templates(templateID)
);

-- 9. Tạo bảng Payments (Quản lý lịch sử và trạng thái thanh toán)
CREATE TABLE Payments (
    paymentID INT IDENTITY(1,1) PRIMARY KEY,
    orderID INT,
    paymentMethod NVARCHAR(50) NOT NULL, -- 'VNPay', 'Momo', 'Bank_Transfer'
    transactionID NVARCHAR(100) NULL, 
    amount DECIMAL(10,2) NOT NULL, 
    paymentStatus NVARCHAR(50) DEFAULT 'Pending', -- 'Pending', 'Success', 'Failed'
    paymentDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (orderID) REFERENCES Orders(orderID)
);

-- 10. Tạo bảng Reviews (Hệ thống đánh giá sản phẩm)
CREATE TABLE Reviews (
    reviewID INT IDENTITY(1,1) PRIMARY KEY,
    templateID INT,
    customerID INT,
    rating INT CHECK (rating >= 1 AND rating <= 5), 
    comment NVARCHAR(MAX),
    createAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (templateID) REFERENCES Templates(templateID),
    FOREIGN KEY (customerID) REFERENCES Users(userID)
); 

-- 11. Tạo bảng Withdrawals (Yêu cầu rút tiền của Designer)
CREATE TABLE Withdrawals (
    withdrawalID INT IDENTITY(1,1) PRIMARY KEY,
    designerID INT,
    amount DECIMAL(10,2) NOT NULL, 
    bankName NVARCHAR(100) NOT NULL, 
    bankAccountNumber NVARCHAR(50) NOT NULL, 
    accountName NVARCHAR(100) NOT NULL, 
    status NVARCHAR(50) DEFAULT 'Pending', -- 'Pending', 'Approved', 'Rejected'
    createAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (designerID) REFERENCES Users(userID)
);

-- ---------------------------------------------------------------------------
-- PHẦN 3: NẠP HỆ THỐNG DỮ LIỆU KIỂM THỬ (MOCK DATA)
-- ---------------------------------------------------------------------------

-- Nạp bảng Roles
INSERT INTO Roles (roleID, roleName) VALUES 
(1, N'Admin'), 
(2, N'Customer'), 
(3, N'Designer');
