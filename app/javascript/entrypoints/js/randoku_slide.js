import Swiper from 'swiper/bundle';
import 'swiper/swiper-bundle.css';
import '../styles/slide.css';

document.addEventListener('DOMContentLoaded', function() {

  const swiperImg = document.querySelector("#swiper_img");
  const updatedAt = document.querySelector("#updated_at");
  const imgName = document.querySelector("#img_name");
  // Todo:htmlの画像のリンクにidを書いて取得する
  const modalTriggers = document.querySelectorAll("#modal_trigger");
  // モーダル
  const modal = document.querySelector(".modal")
  const closeButton = document.querySelector("#close-btn")
  // swiper
  const prevButton = document.querySelector("#button-prev")
  const nextButton = document.querySelector("#button-next")
  const swiperScale = document.querySelector(".swiper").swiper;

  // モーダルを閉じる
  closeButton.addEventListener("click", (e) => {
    modal.classList.remove('active');
  });
  // window.addEventListener("click", (e) => {
    // if(e.target === modal) {
      // modal.classList.remove('active');
    // }
  // });

  // モーダルを開く
  // if (modalTriggers) {
    // modalTriggers.forEach(trigger => {
      // trigger.addEventListner("click", (e) => {
       //// キャッシュあり
        // swiperImg.src = trigger.src.replace("thumb/", "");
      ////  swiperImg.src = trigger.src.replace(/thumb\/|\?#{Time.now.to_i}/g, '/');
        // modal.style.display = "block";
      // });
    // });
  // }
//

  if (modalTriggers) {
    modalTriggers.forEach(trigger => {
      trigger.addEventListener('click', modalOpen);
    });
  }
  function modalOpen() {
    modal.classList.add("active");
  }


//  // 画像の高さを揃える
//  // Note：cssで対応するので使わないかも
//  function matchHeight(elements) {
//    const targets =
//      Array.from(document.querySelectorAll(elements));
//    const heightList = [];
//    targets.forEach(element => {
//      const height = element.clientHeight;
//      heightList.push(height);
//    });
//    const maxHeight = Math.max.apply(null,heightList);
//    targets.forEach(element => {
//      element.style.height = maxHeight + 'px'; // 最大高さに揃える
//    });
//  }



  const swiper = new Swiper(".swiper", {
    // modules: [Navigation, Pagination],
    // direction: 'vertical',
    // loop: true,
    pagination: {
      el: '.swiper-pagination',
      type: "fraction"
    },
    navigation: {
      nextEl: '.swiper-button-next',
      prevEl: '.swiper-button-prev',
    },
  });

  let resizeTimer;

  window.addEventListener('resize', function() {
    clearTimeout(resizeTimer);
    resizeTimer = setTimeout(function() {
      swiper.update();
    }, 500);
  });
});
