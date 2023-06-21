import Swiper from 'swiper/bundle';
import { hideJudgePopupMessages } from './randoku_slide_is_alreadyread.js';
import { js_flash, js_flash_alert } from './flash.js';
import { initializePanzoom, zoomInOut, setupZoomEvents, outputZoomString } from './panzoom.js';

document.addEventListener('DOMContentLoaded', function () {
  const swiper = new Swiper('.swiper', {
    slidesPerView: 'auto',
    centeredSlides: true,
    resizeObserver: true,
    simulateTouch: false, // disable swiper's drag and drop
    height: 'auto',
    pagination: {
      el: '.swiper-pagination',
      type: 'fraction',
    },
    navigation: {
      nextEl: '.swiper-button-next',
      prevEl: '.swiper-button-prev',
    },
  });

  swiper.on('slideChange', function () {
    // 現在のスライドを取得
    const currentSlide = this.slides[this.activeIndex];
    const panzoomEl = currentSlide.querySelector('.panzoom');
    const imgEl = panzoomEl.querySelector('.panzoom-img');
    const printZoomEl = currentSlide.querySelector('.print-zoom');

    // zoomの操作ボタンを取得
    const zoomInEl = document.querySelector('.zoomIn');
    const zoomOutEl = document.querySelector('.zoomOut');
    const zoomResetEl = document.querySelector('.zoomReset');

    const instance = initializePanzoom(panzoomEl);
    setupZoomEvents(panzoomEl, instance, zoomInEl, zoomOutEl, zoomResetEl);
    outputZoomString(instance, printZoomEl);
  });

  // モーダルを開く。クリックされた画像からスライドを始める
  const modalTriggers = document.querySelectorAll('#sw_modal_trigger') || [];

  const modal = document.querySelector('.sw-modal');

  modalTriggers.forEach((trigger) => {
    trigger.addEventListener('click', () => {
      const slideIndex = trigger.dataset.slideIndex;
      swiper.slideTo(slideIndex);
      modal.classList.add('active');
    });
  });

  // モーダルを閉じる
  const closeButton = document.querySelector('#sw-close-btn');

  closeButton.addEventListener('click', () => {
    modal.classList.remove('active');
    hideJudgePopupMessages(); // すべての judge_popup_message を非表示にする
    closeFlash();
  });
});
