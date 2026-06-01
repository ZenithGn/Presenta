/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
// assets/js/toast.js
document.addEventListener("DOMContentLoaded", function () {
    var toast = document.getElementById("custom-toast");
    if (toast) {
        // Tự động tắt ẩn hiệu ứng sau 3 giây
        setTimeout(function () {
            toast.classList.remove("show");
        }, 3000);
    }
});

window.onload = function () {
    const urlParams = new URLSearchParams(window.location.search);
    const activeTab = urlParams.get('tab');
    if (activeTab) {
        switchTab('tab-' + activeTab, document.getElementById('nav-tab-' + activeTab));
    }
    // Toast alert logic...
    let toast = document.getElementById('toastAlert');
    if (toast) {
        toast.style.display = 'block';
        setTimeout(() => {
            toast.style.display = 'none';
        }, 3000);
    }
};

