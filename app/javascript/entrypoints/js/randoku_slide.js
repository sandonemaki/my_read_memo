import Swiper from 'swiper/bundle';
import { hideJudgePopupMessages } from './randoku_slide_is_alreadyread.js'
import { js_flash, js_flash_alert } from './flash.js'

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
    hideJudgePopupMessages(); // すべての judge_popup_message を非表示にする
    closeFlash();
  });

});