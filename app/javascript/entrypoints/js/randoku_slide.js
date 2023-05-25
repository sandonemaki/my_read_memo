import Swiper from 'swiper/bundle';
import 'swiper/swiper-bundle.css';

document.addEventListener('DOMContentLoaded', function() {

  const swiper = new Swiper(".swiper", {
    slidesPerView: 'auto',//スライドの余白を自動調整
    centeredSlides: true, //中央揃え
    resizeObserver: true, //コンテナのリサイズ。スマホ
    zoom: {
      enabled: true
    },
    height: 'auto',
    pagination: {
      el: '.swiper-pagination',
      type: "fraction"
    },
    navigation: {
      nextEl: '.swiper-button-next',
      prevEl: '.swiper-button-prev',
    },
  });

  // モーダルを開く。クリックされた画像からスライドを始める
  const modalTriggers = document.querySelectorAll("#sw_modal_trigger") || [];
  const modal = document.querySelector(".sw-modal")

  modalTriggers.forEach(trigger => {
    trigger.addEventListener('click', () => {
      const slideIndex = trigger.dataset.slideIndex;
      swiper.slideTo(slideIndex);
      modal.classList.add('active');
    });
  });

  // モーダルを閉じる
  const closeButton = document.querySelector("#sw-close-btn")

  closeButton.addEventListener("click", () => {
    modal.classList.remove('active');
  });


  const readBtnList = document.querySelectorAll('#sw_read_btn') || [];

  // 未読・既読/toggle-button
  readBtnList.forEach(readBtn => {
    readBtn.addEventListener('click', async () => {
      await ToggleImgAlreadyReadStatus(readBtn)
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
        'X-CSRF-Token': getCsrfToken()
      },
      body: JSON.stringify(updateData),
    });
    const responseData = await response.json();
    console.log(responseData);

    if (!response.ok) {
      console.error(`${response.status} ${responseData.message}`);
      return
    }
    if (response.ok) {
      // リクエスト成功時の処理
      readBtn.setAttribute('data-reading-id', responseData.img_reading_state_result);
      toggleImgAlreadyReadStateBtn(readBtn);
    }
  }

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
  }

  const getCsrfToken = () => {
    const metalist = document.getElementsByTagName('meta');
    for (let meta of metalist) {
      if (meta.getAttribute('name') === 'csrf-token') {
        return meta.getAttribute('content');
      }
    }
    throw new Error('CSRF token meta tag not found');
  }
});