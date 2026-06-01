/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
function switchTab(tabId, element) {
    document.querySelectorAll('.menu-item').forEach(el => el.classList.remove('active'));
    element.classList.add('active');
    document.querySelectorAll('.tab-pane').forEach(el => el.classList.remove('active'));
    document.getElementById(tabId).classList.add('active');
}

// Đóng mở Modal Đánh Giá
function openReviewModal(id, title) {
    document.getElementById('reviewTemplateId').value = id;
    document.getElementById('reviewTemplateName').innerText = title;
    document.getElementById('reviewModal').style.display = 'flex';
}
function closeReviewModal() {
    document.getElementById('reviewModal').style.display = 'none';
}

// Tự động tắt thông báo Toast sau 3 giây
window.onload = function () {
    let toast = document.getElementById('toastAlert');
    if (toast) {
        toast.style.display = 'block';
        setTimeout(() => {
            toast.style.display = 'none';
        }, 3000);
    }
};

// =======================================================
// JS XỬ LÝ UPLOAD VÀ PREVIEW AVATAR
// =======================================================

const fileInput = document.getElementById('avatar-file-input');
const mainImg = document.getElementById('main-avatar-img');
const placeholder = document.getElementById('main-avatar-placeholder');

// Hàm 1: Khi click vào vòng tròn avatar bên trái -> kích hoạt input file click
function triggerFileUpload() {
    fileInput.click();
}

// Hàm 2: Lắng nghe sự kiện input file thay đổi (người dùng đã chọn file)
fileInput.addEventListener('change', function () {
    const file = this.files[0];
    if (file) {
        // Kiểm tra loại file (chỉ chấp nhận ảnh)
        if (!file.type.startsWith('image/')) {
            alert("Vui lòng chỉ chọn file hình ảnh!");
            this.value = ""; // Reset input
            return;
        }
        // Kiểm tra kích thước (ví dụ chặn > 10MB)
        if (file.size > 10 * 1024 * 1024) {
            alert("Kích thước file quá lớn (tối đa 10MB)!");
            this.value = ""; // Reset input
            return;
        }

        // Dùng FileReader để đọc file và hiển thị preview ngay lập tức (chưa lưu)
        const reader = new FileReader();
        reader.onload = function (e) {
            // Cập nhật nguồn ảnh preview
            mainImg.src = e.target.result;
            mainImg.style.display = 'block'; // Hiện img
            if (placeholder)
                placeholder.style.display = 'none'; // Ẩn chữ cái placeholder

            // Toast nhẹ báo người dùng bấm nút Lưu
            document.getElementById('nav-tab-info').click(); // Chuyển sang tab cài đặt
            alert("Ảnh mới đã được chọn! Bấm nút 'Lưu Ảnh Đại Diện Mới' trong phần cài đặt để hoàn tất.");
        }
        reader.readAsDataURL(file);
    }
});

