import { getCsrfToken } from './get_csrf_token.js';

document.addEventListener('DOMContentLoaded', function () {
  const readBtnList = document.querySelectorAll('#sw_read_btn') || [];

  // 未読・既読/toggle-button
  readBtnList.forEach((readBtn) => {
    readBtn.addEventListener('click', async () => {
      await ToggleImgAlreadyReadStatus(readBtn);
    });
  });

  const ToggleImgAlreadyReadStatus = async (readBtn) => {
    const readingId = parseInt(readBtn.getAttribute('data-reading-id'));
    const imgId = parseInt(readBtn.getAttribute('data-img-id'));
    const bookId = parseInt(readBtn.getAttribute('data-book-id'));
    const updateData = {
      already_read_toggle: readingId,
    };

    const response = await fetch(`/books/${bookId}/imgs/${imgId}/toggle_already_read`, {
      method: 'PUT',
      credentials: 'same-origin',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': getCsrfToken(),
      },
      body: JSON.stringify(updateData),
    });
    const responseData = await response.json();

    if (!response.ok) {
      js_flash_alert(responseData.message);
      throw new Error(`${response.status} ${responseData.message}`);
    }

    if (response.ok) {
      readBtn.setAttribute('data-reading-id', responseData.img_reading_state_result);
      toggleImgAlreadyReadStateBtn(readBtn);
      judge_popup_message(responseData);
      img_already_read_check_update(imgId, responseData);
      img_read_status_count_update(responseData);
      book_reading_progress_update(responseData);
      book_seidoku_memo_key(responseData);
      book_seidoku_remaining(responseData);
    }
  };
});

// 乱読画像の状態が / トータルページが
// update される -> 乱読画像の未読・既読の数が変わる -> 精読なら精読メモタブの鍵を外す
export const book_seidoku_memo_key = (responseData) => {
  const seidokuMemoKeyWord = document.querySelector('.seidoku_memo_key');
  const seidokuMemoTab = document.querySelector('[data-tab="03"]');
  if (responseData.book_seidoku_memo_key === 'key_false' && seidokuMemoKeyWord && seidokuMemoTab) {
    seidokuMemoKeyWord.remove();
    seidokuMemoTab.classList.remove('tab-disabled');
  }
};

// 乱読画像の状態が / トータルページが
// update される -> 乱読画像の未読・既読の数が変わる -> 本の状態を更新
export const book_reading_progress_update = (responseData) => {
  const book_reading_progress_list = document.querySelectorAll('.book_reading_progress');
  book_reading_progress_list.forEach((book_reading_progress) => {
    if (responseData.book_state_updated_info) {
      book_reading_progress.textContent = responseData.book_state_updated_info;
    }
  });
};

// 乱読画像の状態が / トータルページが
// update される -> 精読までの枚数を更新
export const book_seidoku_remaining = (responseData) => {
  const seidoku_remainings = document.querySelectorAll('.seidoku-remaining-js');
  seidoku_remainings.forEach((seidoku_remaining) => {
    seidoku_remaining.textContent = responseData.remaining;
  });
};

// 乱読画像の状態が update される -> 乱読画像の未読/既読の数を更新
const img_read_status_count_update = (responseData) => {
  const img_read_status_count = document.querySelector('.randoku_imgs_unread_count');
  // responseDataから変数を取り出す
  const img_unread_count = responseData.img_unread_count;
  // const img_already_read_count = responseData.img_already_read_count;
  if (img_unread_count !== undefined) {
    img_read_status_count.textContent = `${img_unread_count}`;
  }
};

// 乱読画像の状態が update される -> 乱読画像の未読/既読 check を更新
const img_already_read_check_update = (imgId, responseData) => {
  const is_already_read_check = document.querySelector(`.is_already_read_check[data-img-id="${imgId}"]`);
  if (responseData.img_reading_state_result === 0) {
    is_already_read_check.textContent = '未読';
  } else {
    is_already_read_check.textContent = '既読';
  }
};

//// 本の状態が変更されたことを知らせるpopup関数 ////
// judge_popup_message を表示するためのセレクターを取得
const seidokuJudgePopupMessage = document.querySelector('#judged-seidoku');
const tudokuJudgePopupMessage = document.querySelector('#judged-tudoku');
const randokuJudgePopupMessage = document.querySelector('#judged-randoku');
const judgePopupCloseButtonList = document.querySelectorAll('.judge-popup__close');

// judge_popup_message を非表示にする関数
export const hideJudgePopupMessages = () => {
  seidokuJudgePopupMessage.classList.add('judge-popup__hidden');
  tudokuJudgePopupMessage.classList.add('judge-popup__hidden');
  randokuJudgePopupMessage.classList.add('judge-popup__hidden');
};

// 本の状態が update される -> 本の状態が更新される -> 対応する judge_popup_message を表示
// モーダルでのトータルページの更新 -> 本の状態が変更 -> popupは表示しない
const judge_popup_message = (responseData) => {
  // クローズボタンで judge_popup_message を非表示にする
  judgePopupCloseButtonList.forEach((judgePopupCloseButton) => {
    judgePopupCloseButton.addEventListener('click', hideJudgePopupMessages);
  });
  if (responseData.book_state_updated_info) {
    hideJudgePopupMessages(); // 一度すべての judge_popup_message を非表示にする
    switch (responseData.book_state_updated_info) {
      case '精読':
        seidokuJudgePopupMessage.classList.remove('judge-popup__hidden');
        break;
      case '通読':
        tudokuJudgePopupMessage.classList.remove('judge-popup__hidden');
        break;
      case '乱読':
        randokuJudgePopupMessage.classList.remove('judge-popup__hidden');
        break;
    }
  }
};

// 読んだボタンの click によるレスポンスの結果に応じてボタンの色やテキストを変更
const toggleImgAlreadyReadStateBtn = (readBtn) => {
  const readingId = parseInt(readBtn.getAttribute('data-reading-id'));
  //readBtn.classList.toggle('completion');
  if (readingId === 0) {
    readBtn.classList.remove('completion');
    readBtn.textContent = '読んだ!';
  } else {
    readBtn.classList.add('completion');
    readBtn.textContent = '完了済み';
  }
};
