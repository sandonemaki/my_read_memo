import Swiper from 'swiper/bundle';
import 'swiper/swiper-bundle.css';

document.addEventListener('DOMContentLoaded', function() {

  const modalTriggers = document.querySelectorAll("#sw_modal_trigger");
  // スライド
  const imgName = document.querySelector("#sw_img_name");
  const imgs = document.querySelectorAll("#swiper_img");
  const updatedAt = document.querySelector("#sw_updated_at");
  const readBtns = document.querySelectorAll('#sw_read_btn');
  // モーダル
  const modal = document.querySelector(".sw-modal")
  const closeButton = document.querySelector("#sw-close-btn")


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
  const slides = document.querySelectorAll(".swiper-slide");
  modalTriggers.forEach(torigger => {
    torigger.addEventListener('click', () => {
      const slideIndex = torigger.dataset.slideIndex;
      swiper.slideTo(slideIndex);
      modal.classList.add('active');
    });
  });

  // モーダルを閉じる
  console.log(closeButton.addEventListener);
  closeButton.addEventListener("click", (e) => {
    modal.classList.remove('active');
  });



  // 未読・既読/toggle-button
  if (readBtns) {
    readBtns.forEach(readBtn => {
      readBtn.addEventListener('click', async () => {
        const readingId = parseInt(readBtn.getAttribute('data-reading-id'));
        const imgId = parseInt(readBtn.getAttribute('data-img-id'));
        const bookId = parseInt(readBtn.getAttribute('data-book-id'));
        const updateData = {
          reading_id: readingId,
          img_id: imgId
        };

        try {
          const response = await fetch(`/books/${bookId}`, {
            method: 'PUT',
            credentials: 'same-origin',
            headers: {
              'Content-Type': 'application/json',
              'X-CSRF-Token': getCsrfToken()
              },
            body: JSON.stringify(updateData),
            })

          if (!response.ok) {
            throw new Error(response.statusText);
            }

          console.log("iiiii")
          //成功時
          readBtn.classList.toggle('completion');
          if (readBtn.classList.contains('completion')) {
            readBtn.setAttribute('data-reading-id', '0');
            readBtn.textContent = '読んだ!';
          } else {
            readBtn.setAttribute('data-reading-id', '1');
            readBtn.textContent = '完了済み';
          }

          } catch (error) {
            console.error('エラーが発生しました', error);
            }
        });
      });
    }


  const getCsrfToken = () => {
    const metas = document.getElementsByTagName('meta');
    for (let meta of metas) {
      if (meta.getAttribute('name') === 'csrf-token') {
        console.log('csrf-token:', meta.getAttribute('content'));
        return meta.getAttribute('content');
        }
      }
    return '';
    }

});
