/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
function loadMoreReviews() {
    // Tìm tất cả các thẻ review đang bị ẩn
    const hiddenReviews = document.querySelectorAll('.js-review-item.review-hidden');

    // Lặp qua 4 thẻ bị ẩn đầu tiên và cho hiện lên
    for (let i = 0; i < 4; i++) {
        if (hiddenReviews[i]) {
            hiddenReviews[i].classList.remove('review-hidden');
        }
    }

    // Nếu không còn thẻ nào bị ẩn nữa, giấu luôn nút "View More" đi
    const remainingHidden = document.querySelectorAll('.js-review-item.review-hidden');
    if (remainingHidden.length === 0) {
        document.getElementById('btnLoadMore').style.display = 'none';
    }
}

