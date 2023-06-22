import { js_flash, js_flash_alert } from './flash.js';
import { book_seidoku_memo_key } from './randoku_slide_is_alreadyread.js';
import { book_reading_progress_update } from './randoku_slide_is_alreadyread.js';
import { getCsrfToken } from './get_csrf_token.js';

document.addEventListener('DOMContentLoaded', function () {
  const totalPageSubmitBtn = document.querySelector('#total_page_submit_btn') || [];

  totalPageSubmitBtn.addEventListener('click', async () => {
    await UpdateTotalPage(totalPageSubmitBtn);
  });

  const UpdateTotalPage = async (totalPageSubmitBtn) => {
    const bookId = parseInt(totalPageSubmitBtn.getAttribute('data-book-id'));
    const inputTotalPage = document.querySelector('#input_total_page').value;
    const updateData = {
      input_total_page: inputTotalPage,
    };

    const response = await fetch(`/books/${bookId}/update_total_page`, {
      method: 'POST',
      credentials: 'same-origin',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': getCsrfToken(),
      },
      body: JSON.stringify(updateData),
    });
    const responseData = await response.json();

    // フラッシュメッセージの要素を取得
    const flashMessage = document.querySelector('.c-flash');

    if (!response.ok) {
      js_flash_alert(responseData.message);
      throw new Error(`${response.status} ${responseData.message}`);
    }

    if (response.ok) {
      js_flash('保存しました');
      book_reading_progress_update(responseData);
      book_seidoku_memo_key(responseData);
      book_update_total_page(responseData);
      book_update_seidoku_standard(responseData);
  };
});

const book_update_total_page = (responseData) => {
  const current_total_page_list = document.querySelectorAll('.js-update-current-total-page');
  current_total_page_list.forEach((current_total_page) => {
    if (responseData.total_page_update_result) {
      current_total_page.textContent = responseData.total_page_update_result;
    }
  });
};