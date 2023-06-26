import { getCsrfToken } from './get_csrf_token.js';
import { js_flash, js_flash_alert } from './flash.js';

document.addEventListener('DOMContentLoaded', function () {
  const randoku_rank_link01 = document.querySelector('.randoku_rank_01 > a');
  const randoku_rank_link02 = document.querySelector('.randoku_rank_02 > a');
  const randoku_rank_link03 = document.querySelector('.randoku_rank_03 > a');
  const rank_links = [randoku_rank_link01, randoku_rank_link02, randoku_rank_link03];

  rank_links.forEach((rank_link) => {
    if (rank_link) {
      rank_link.addEventListener('click', async (event) => {
        event.preventDefault();
        await rankSort(rank_link);
      });
    }
  });

  const rankSort = async (rank_link) => {
    const url = rank_link.href;

    // Fetchを用いて画像を取得
    const response = await fetch(url, {
      method: 'GET',
      credentials: 'same-origin',
      headers: {
        'X-CSRF-Token': getCsrfToken(), // getCsrfToken は既存の関数を利用
      },
    });
    const responseData = await response.json();

    // フラッシュメッセージの要素を取得
    const flashMessage = document.querySelector('.c-flash');

    if (!response.ok) {
      js_flash_alert(`ランキングの取得に失敗しました`);
      throw new Error(`${response.status} ${responseData.message}`);
    }

    if (response.ok) {
      randoku_pre_lesson_update(responseData);
      randoku_index_rank_update(responseData);
    }
  };

  const randoku_pre_lesson_update = (responseData) => {
    // 'books/index_tabs/_randoku_index_pre_lesson_common' の変数
    const randoku_books = responseData.randoku_books;

    if (!randoku_books?.randoku_history) {
      const no_randoku_history = document.querySelector('.no-randoku-history.pre');
      no_randoku_history.textContent = '乱読画像を投稿してメモを再読する必要性を伝える';
    }

    const indexCrownIcon = document.querySelector('.index-crown.pre');
    if (randoku_books.randoku_history.randoku_history_ranking) {
      indexCrownIcon.style.display = 'inline'; // アイコンを表示する
    }

    const index_book_title = document.querySelector('.index-book-title.pre');
    const index_book_progress = document.querySelector('.index-book-progress.pre');
    const index_book_imgs_count = document.querySelector('.index-book-memo-count.imgs.pre');
    const index_book_memos_count = document.querySelector('.index-book-memo-count.memos.pre');

    index_book_title.textContent = randoku_books.randoku_history['title'];
    index_book_progress.textContent = randoku_books.randoku_history['reading_state'];
    index_book_imgs_count.textContent = randoku_books.randoku_history['randoku_imgs_count'];
    index_book_memos_count.textContent = randoku_books.randoku_history['randoku_memos_count'];
  };

  const randoku_index_rank_update = (responseData) => {
    const randoku_ranks = responseData.randoku_rank;

    if (!randoku_ranks?.books_index_rank?.length) {
      const no_randoku_history = document.querySelector('.no-rank-book');
      no_randoku_history.textContent = '乱読中の本がありません';
    }

    randoku_ranks?.books_index_rank?.forEach((book, index) => {
      // Prefix selector with index
      const book_index = `.book-${index}`;
      const book_id = `.book-${book['id']}`;
      const indexCrownIcon = document.querySelector(`${book_id} .index-crown.rank`);
      const index_book_title = document.querySelector(`${book_id} .index-book-title.rank`);
      const index_book_progress = document.querySelector(`${book_id} .index-book-progress.rank`);
      const index_book_imgs_count = document.querySelector(`${book_id} .index-book-memo-count.imgs.rank`);
      const index_book_memos_count = document.querySelector(`${book_id} .index-book-memo-count.memos.rank`);

      // If book is ranking, display the crown icon
      if (book.randoku_ranking) {
        if (book.randoku_ranking === '') {
          // randoku_rankingが空文字列
          indexCrownIcon.style.display = 'none'; // アイコンを非表示にする
        } else {
          indexCrownIcon.style.display = 'inline'; // アイコンを表示する
        }
      }

      console.log(index_book_title);
      console.log(index_book_imgs_count);
      console.log(index_book_memos_count);
      // console.log(book_index);

      index_book_title.textContent = book['title'];
      index_book_imgs_count.textContent = book['randoku_imgs_count'];
      index_book_memos_count.textContent = book['randoku_memos_count'];
    });
  };
});
