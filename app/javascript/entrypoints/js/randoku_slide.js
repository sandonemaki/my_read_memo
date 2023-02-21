import Swiper from 'swiper/bundle';
import 'swiper/swiper-bundle.css';
import '../styles/slide.css';

const swiper = new Swiper(".swiper", {
  // modules: [Navigation, Pagination],
  direction: 'vertical',
  loop: true,
  pagination: {
    el: '.swiper-pagination',
  },
  navigation: {
    nextEl: '.swiper-button-next',
    prevEl: '.swiper-button-prev',
  },
  scrollbar: {
    el: '.swiper-scrollbar',
  },
});

