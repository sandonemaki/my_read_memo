import { getCsrfToken } from './get_csrf_token.js';
import { js_flash_alert } from './flash.js';

document.addEventListener('DOMContentLoaded', function() {

  const downloadBtns = document.querySelectorAll(".download-btn");

  downloadBtns.forEach(download_btn => {
    download_btn.addEventListener('click', async () => {
      await downloadImg(download_btn)
    });
  });

  const downloadImg = async (download_btn) => {
    // スライドから画像の情報を取得
    const currentSlide = document.querySelector('.swiper-slide-active'); //swiperのcss
    const imgElement = currentSlide.querySelector('.sw_img img');
    const url = imgElement.dataset.imgPath;
    const fileName = download_btn.getAttribute('data-img-name');

}