import Swiper from 'swiper/bundle';
import 'swiper/swiper-bundle.css';
import '../styles/slide.css';

document.addEventListener('DOMContentLoaded', function() {
  const img = document.querySelector("#img");
  const updated_at = document.querySelector("#updated_at");
  const img_name = document.querySelector("#img_name");
  // Todo:htmlの画像のリンクにidを書いて取得する
  const links = document.querySelector("a[id^='photo-link-']");
  // モーダル
  const modal = document.querySelector("#modal")
  const modalImage = document.querySelector("#modal-image")
  const closeButton = document.querySelector("#close-button")
  // swiper
  const prevButton = document.querySelector("#button-prev")
  const nextButton = document.querySelector("#button-next")



  // モーダルを閉じる
  closeButton.addEventListener("click", (e) => {
    modal.style.display = "none";
  });
  window.addEventListener("click", (e) => {
    if(e.target === modal) {
      modal.style.display = "none";
    }
  });

  // モーダルを開く
  for (let i = 0; i < links.length; i++) {
    links[i].addEventListner("click", (e) => {
      const photoId = e.target.id.split("-")[2];
      // Todo:クリックされた画像を拡大表示する
      modal.style.display = "block";
    });
  }



  // 画像の高さを揃える
  function matchHeight(elements) {
    const targets =
      Array.from(document.querySelectorAll(elements));
    const heightList = [];
    targets.forEach(element => {
      const height = element.clientHeight;
      heightList.push(height);
    });
    const maxHeight = Math.max.apply(null,heightList);
    targets.forEach(element => {
      element.style.height = maxHeight + 'px'; // 最大高さに揃える
    });
  }
  matchHeight(".img");



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
});
