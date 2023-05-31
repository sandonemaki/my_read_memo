import { js_flash } from './flash.js'
import { book_seidoku_memo_key } from './randoku_slide_is_alreadyread.js'
import { book_reading_progress_update } from './randoku_slide_is_alreadyread.js'
import { getCsrfToken } from './get_csrf_token.js';

document.addEventListener('DOMContentLoaded', function() {
  const totalPageSubmitBtn = document.querySelector('#total_page_submit_btn') || [];

  totalPageSubmitBtn.addEventListener('click', async () => {
    await UpdateTotalPage(totalPageSubmitBtn)
  });

  const UpdateTotalPage = async (totalPageSubmitBtn) => {
    const bookId = parseInt(totalPageSubmitBtn.getAttribute('data-book-id'));
    const inputTotalPage = document.querySelector('#input_total_page').value
    const updateData = {
      input_total_page: inputTotalPage
    };

    const response = await fetch(`/books/${bookId}/update_total_page`, {
      method: 'POST',
      credentials: 'same-origin',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': getCsrfToken()
      },
      body: JSON.stringify(updateData),
    });
    const responseData = await response.json();

    // フラッシュメッセージの要素を取得
    const flashMessage = document.querySelector('.c-flash');

    if (!response.ok) {
      flashMessage.classList.remove('c-flash--notice');
      flashMessage.classList.add('c-flash--alert');
      js_flash({ flashMessage: flashMessage, input_message: "保存に失敗しました" });
      throw new Error(`${response.status} ${responseData.message}`);
    }

    if (response.ok) {
      js_flash({ flashMessage: flashMessage, input_message: "保存しました" });
      book_reading_progress_update(responseData);
      book_seidoku_memo_key(responseData);
    }
  }

});