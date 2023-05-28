document.addEventListener('DOMContentLoaded', function() {
  const bookmarkBtnList = document.querySelectorAll('.sw_bookmark_btn') || [];

  // bookmark/toggle-button
  bookmarkBtnList.forEach(bookmarkBtn => {
    bookmarkBtn.addEventListener('click', async () => {
      await ToggleImgBookmarkStatus(bookmarkBtn)
    });  
  });

  const ToggleImgBookmarkStatus = async (bookmarkBtn) => { 
    const bookmarkId = parseInt(bookmarkBtn.getAttribute('data-bookmark-id'));
    const imgId = parseInt(bookmarkBtn.getAttribute('data-img-id'));
    const bookId = parseInt(bookmarkBtn.getAttribute('data-book-id'));
    const updateData = {
      bookmark_toggle: bookmarkId,
    };

    const response = await fetch(`/books/${bookId}/imgs/${imgId}/toggle_bookmark`, {
      method: 'PUT',
      credentials: 'same-origin',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': getCsrfToken()
      },
      body: JSON.stringify(updateData),
    });
    const responseData = await response.json();
    console.log(responseData);

    if (!response.ok) {
      alert(`${response.status} ${responseData.message}`);
      throw new Error(`${response.status} ${responseData.message}`);
    }

    if (response.ok) {
      bookmarkBtn.setAttribute('data-bookmark-id', responseData.img_bookmark_flag_result);
      toggleImgBookmarkFlagBtn(bookmarkBtn);
      //img_already_read_check_update(responseData);
    }
  }
  // bookmarkボタンをclickしたことによりbookmarkのclassと文字を変更
  const toggleImgBookmarkFlagBtn = (bookmarkBtn) => {
    const bookmarkId = parseInt(bookmarkBtn.getAttribute('data-bookmark-id'));
    if (bookmarkId === 0) {
      bookmarkBtn.innerHTML = '<i class="fa-regular fa-bookmark fa-2xl"></i>'; //off
    } else {
      bookmarkBtn.innerHTML = '<i class="fa-solid fa-bookmark fa-2xl"></i>'; //on
    }
  }

  // 乱読画像の状態が update されたら乱読画像の未読/既読 check を更新
  // const img_already_read_check_update = (responseData) => {
  //   const is_already_read_check_list = document.querySelectorAll('.is_already_read_check');
  //   is_already_read_check_list.forEach(is_already_read_check => {
  //     if (responseData.img_reading_state_result === 0) {
  //       is_already_read_check.textContent = '未読';
  //     } else {
  //       is_already_read_check.textContent = '既読';
  //     }
  //   });
  // }

  const getCsrfToken = () => {
    const metalist = document.getElementsByTagName('meta');
    for (let meta of metalist) {
      if (meta.getAttribute('name') === 'csrf-token') {
        return meta.getAttribute('content');
      }
    }
    alert('エラーが発生しました: CSRF token metatag が見つかりません。 ページを更新して、もう一度お試しください');
    throw new Error('CSRF token meta tag not found');
  }
});