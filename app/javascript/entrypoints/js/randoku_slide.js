import Swiper from 'swiper/bundle';
import 'swiper/swiper-bundle.css';
import '../styles/slide.css';

document.addEventListener('DOMContentLoaded', function() {

  const modalTriggers = document.querySelectorAll("#modal_trigger");
  // スライド
  const imgName = document.querySelector("#img_name");
  const imgs = document.querySelectorAll("#swiper_img");
  const updatedAt = document.querySelector("#updated_at");
  // モーダル
  const modal = document.querySelector(".modal")
  const closeButton = document.querySelector("#close-btn")
  // swiper
  const prevButton = document.querySelector("#button-prev")
  const nextButton = document.querySelector("#button-next")



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
  closeButton.addEventListener("click", (e) => {
    modal.classList.remove('active');
  });
});
