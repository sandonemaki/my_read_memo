import Swiper from 'swiper/bundle';
import 'swiper/swiper-bundle.css';
import '../styles/slide.css';

document.addEventListener('DOMContentLoaded', function() {
  const img = document.querySelector(".img");
  const updated_at = document.querySelector(".updated_at");
  const img_name = document.querySelector(".img_name");

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
