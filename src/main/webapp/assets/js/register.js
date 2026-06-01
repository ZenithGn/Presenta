/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
function switchRole(role) {
    const tabCustomer = document.getElementById('tabCustomer');
    const tabDesigner = document.getElementById('tabDesigner');
    const designerFields = document.getElementById('designerFields');
    const roleInput = document.getElementById('roleID');

    const phoneInput = document.getElementById('phone');

    if (role === 'customer') {
        // Kích hoạt tab Customer
        tabCustomer.classList.add('active');
        tabDesigner.classList.remove('active');

        // Ẩn form Designer và set roleID = 2
        designerFields.classList.remove('active');
        roleInput.value = '2';

        // Xóa trạng thái bắt buộc nhập
        phoneInput.removeAttribute('required');
    } else {
        // Kích hoạt tab Designer
        tabDesigner.classList.add('active');
        tabCustomer.classList.remove('active');

        // Hiện form Designer và set roleID = 3
        designerFields.classList.add('active');
        roleInput.value = '3';

        // Thêm trạng thái bắt buộc nhập cho Phone
        phoneInput.setAttribute('required', 'true');
    }
}

