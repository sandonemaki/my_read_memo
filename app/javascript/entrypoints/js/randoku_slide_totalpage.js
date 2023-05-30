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
    console.log(responseData);

    if (!response.ok) {
      alert(`${response.status} ${responseData.message}`);
      throw new Error(`${response.status} ${responseData.message}`);
    }

    if (response.ok) {
      //judge_popup_message(responseData);
      //book_reading_progress_update(responseData);
      //book_seidoku_memo_key(responseData);
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


  // totalpageのモーダル
  // Open the modal
  function openModal() {
    const modal = document.querySelector('.ModalWrapper');
    const overlay = document.querySelector('.ModalOverlay');
    modal.classList.add('show');
    overlay.classList.add('show');
  }

  // Close the modal
  function closeModal() {
    const modal = document.querySelector('.ModalWrapper');
    const overlay = document.querySelector('.ModalOverlay');
    modal.classList.remove('show');
    overlay.classList.remove('show');
  }
  console.log("dddd")
  // Attach event listener to the open button
  // document.querySelector('#open-totalpage-modal').addEventListener('click', openModal);
  document.querySelector('#open-totalpage-modal').addEventListener('click', function() {
    console.log('Button clicked!'); // デバッグメッセージ
    openModal();
  });
  

  // Attach event listener to the close button
  document.querySelector('.ModalCloseButton').addEventListener('click', closeModal);
});