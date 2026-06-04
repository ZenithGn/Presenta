/**
 * Designer Account JS - Tab switching, avatar preview, auto-init
 * Used by views/designer/designer-profile.jsp (designer's own profile page)
 */
function switchTab(tabId, element) {
    var menuItems = document.querySelectorAll('.menu-item');
    for (var i = 0; i < menuItems.length; i++) {
        menuItems[i].classList.remove('active');
    }
    element.classList.add('active');

    var tabPanes = document.querySelectorAll('.tab-pane');
    for (var j = 0; j < tabPanes.length; j++) {
        tabPanes[j].classList.remove('active');
    }
    document.getElementById(tabId).classList.add('active');
}

// Avatar upload trigger
var fileInput = document.getElementById('avatar-file-input');
var mainImg = document.getElementById('main-avatar-img');
var placeholder = document.getElementById('main-avatar-placeholder');

function triggerFileUpload() {
    if (fileInput) fileInput.click();
}

if (fileInput) {
    fileInput.addEventListener('change', function () {
        var file = this.files[0];
        if (!file) return;
        if (!file.type.startsWith('image/')) {
            alert('Please select an image file!');
            this.value = '';
            return;
        }
        if (file.size > 10 * 1024 * 1024) {
            alert('File too large (max 10MB)!');
            this.value = '';
            return;
        }
        var reader = new FileReader();
        reader.onload = function (e) {
            if (mainImg) {
                mainImg.src = e.target.result;
                mainImg.style.display = 'block';
            }
            if (placeholder) placeholder.style.display = 'none';
            var infoTab = document.getElementById('nav-tab-info');
            if (infoTab) infoTab.click();
            alert('Image selected! Click "Upload New Avatar" to save.');
        };
        reader.readAsDataURL(file);
    });
}

// Toast auto-hide
window.addEventListener('DOMContentLoaded', function () {
    var toast = document.getElementById('toastAlert');
    if (toast) {
        toast.style.display = 'block';
        setTimeout(function () {
            toast.style.display = 'none';
        }, 3000);
    }
});
