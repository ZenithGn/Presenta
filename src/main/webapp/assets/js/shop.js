/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
document.addEventListener("DOMContentLoaded", function () {
    // Lấy các tham số trên URL
    const urlParams = new URLSearchParams(window.location.search);

    // Nếu URL có chứa keyword, categoryID hoặc index (nghĩa là user vừa search hoặc chuyển trang)
    if (urlParams.has('keyword') || urlParams.has('categoryID') || urlParams.has('index')) {

        const target = document.getElementById('shop-content');
        if (target) {
            // Tính toán vị trí cần cuộn, trừ đi 100px để không bị Navbar (sticky) đè lên
            const headerOffset = 100;
            const elementPosition = target.getBoundingClientRect().top;
            const offsetPosition = elementPosition + window.pageYOffset - headerOffset;

            // Cuộn mượt mà xuống khu vực sản phẩm
            window.scrollTo({
                top: offsetPosition,
                behavior: "smooth"
            });
        }
    }
});

// Tự động tắt Toast sau 3 giây (3000ms)
