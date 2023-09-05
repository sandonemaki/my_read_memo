import { js_flash, js_flash_alert } from './flash.js';
import { book_seidoku_memo_key } from './randoku_slide_is_alreadyread.js';
import { book_reading_progress_update } from './randoku_slide_is_alreadyread.js';
import { getCsrfToken } from './get_csrf_token.js';

document.addEventListener('DOMContentLoaded', function () {
  const totalPageSubmitBtn = document.querySelector('#total_page_submit_btn_js');
  if (totalPageSubmitBtn) {
    totalPageSubmitBtn.addEventListener('click', async () => {
      await UpdateTotalPage(totalPageSubmitBtn);
    });

    const UpdateTotalPage = async (totalPageSubmitBtn) => {
      const bookId = parseInt(totalPageSubmitBtn.getAttribute('data-book-id'));
      const inputTotalPage = document.querySelector('#input_total_page_slide_js').value;
      const updateData = {
        input_total_page: inputTotalPage,
      };

      const response = await fetch(`/books/${bookId}/update_total_page`, {
        method: 'PUT',
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
        book_seidoku_remaining(responseData);
      }
    };
  }
});

// さらさら読書画像メモの状態が / トータルページが
// update される ->　じっくり読書までの枚数を更新
export const book_seidoku_remaining = (responseData) => {
  const seidoku_remainings = document.querySelectorAll('.seidoku-remaining-js');
  seidoku_remainings.forEach((seidoku_remaining) => {
    seidoku_remaining.textContent = responseData.remaining;
  });
};

const book_update_total_page = (responseData) => {
  const current_total_page_list = document.querySelectorAll('.js-update-current-total-page');
  current_total_page_list.forEach((current_total_page) => {
    if (responseData.total_page_update_result) {
      current_total_page.textContent = responseData.total_page_update_result;
    }
  });
};

const book_update_seidoku_standard = (responseData) => {
  const book_seidoku_line_1_list = document.querySelectorAll('.book_seidoku_line_1');
  book_seidoku_line_1_list.forEach((book_seidoku_line_1) => {
    if (responseData.seidoku_line_1) {
      book_seidoku_line_1.textContent = responseData.seidoku_line_1;
    }
  });

  const book_seidoku_line_2_list = document.querySelectorAll('.book_seidoku_line_2');
  book_seidoku_line_2_list.forEach((book_seidoku_line_2) => {
    if (responseData.seidoku_line_2) {
      book_seidoku_line_2.textContent = responseData.seidoku_line_2;
    }
  });
};
