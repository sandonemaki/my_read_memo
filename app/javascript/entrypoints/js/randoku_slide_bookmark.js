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
      img_bookmark_flag_check_update(imgId, responseData);
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

  // 乱読画像のbookmarkのflagが update されたら乱読画像の bookmark の check を更新
  const img_bookmark_flag_check_update = (imgId, responseData) => {
    const img_bookmark_check = document.querySelector(`.img_bookmark_check[data-img-id="${imgId}"]`);
    if (responseData.img_bookmark_flag_result === 0) {
      img_bookmark_check.innerHTML = '<i class="fa-regular fa-bookmark"></i>'; //off
    } else {
      img_bookmark_check.innerHTML = '<i class="fa-solid fa-bookmark"></i>'; //on
    }
  }

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