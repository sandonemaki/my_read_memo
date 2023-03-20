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

  modalTriggers.forEach(torigger => {
    torigger.addEventListener('click', () => {
      const slideIndex = torigger.dataset.slideIndex;
      swiper.slideTo(slideIndex);
      modal.classList.add('active');
    });
  });

  // モーダルを閉じる
  const closeButton = document.querySelector("#sw-close-btn")

  closeButton.addEventListener("click", () => {
    modal.classList.remove('active');
  });


	const readBtns = document.querySelectorAll('#sw_read_btn') || [];

  // 未読・既読/toggle-button
  readBtns.forEach(readBtn => {
    readBtn.addEventListener('click', async () => {
      const readingId = parseInt(readBtn.getAttribute('data-reading-id'));
      const imgId = parseInt(readBtn.getAttribute('data-img-id'));
      const bookId = parseInt(readBtn.getAttribute('data-book-id'));
      const updateData = {
        alreadyread_toggle: readingId,
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

      if (response.ok) {
        // リクエスト成功時の処理
        readBtn.classList.toggle('completion');
        if (readBtn.classList.contains('completion')) {
          readBtn.setAttribute('data-reading-id', '0');
          readBtn.textContent = '読んだ!';
        } else {
          readBtn.setAttribute('data-reading-id', '1');
          readBtn.textContent = '完了済み';
        }
      } else {
        // リクエスト失敗時の処理
        console.error('エラーが発生しました', response.statusText);
      }
    });
  });

  const getCsrfToken = () => {
    const metas = document.getElementsByTagName('meta');
    for (let meta of metas) {
      if (meta.getAttribute('name') === 'csrf-token') {
        return meta.getAttribute('content');
      }
    }
		throw new Error('CSRF token meta tag not found');
  }
});
