import { getCsrfToken } from './get_csrf_token.js';
import { js_flash_alert } from './flash.js';

document.addEventListener('DOMContentLoaded', function () {
  const downloadBtns = document.querySelectorAll('.download-btn');

  downloadBtns.forEach((download_btn) => {
    download_btn.addEventListener('click', async () => {
      await downloadImg(download_btn);
    });
  });

  const downloadImg = async (download_btn) => {
    // スライドから画像の情報を取得
    const currentSlide = document.querySelector('.swiper-slide-active'); //swiperのcss
    const imgElement = currentSlide.querySelector('.sw_img img');
    const url = imgElement.dataset.imgPath;
    const fileName = imgElement.dataset.imgName;
    //const fileName = download_btn.getAttribute('data-img-name');

    // Fetchを用いて画像を取得
    const response = await fetch(url, {
      method: 'GET',
      credentials: 'same-origin',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': getCsrfToken(), // getCsrfToken は既存の関数を利用
      },
    });

    if (!response.ok) {
      js_flash_alert(`ダウンロードに失敗しました`);
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    // Blob としてレスポンスを取得
    const blob = await response.blob();

    // IE用
    if (window.navigator.msSaveOrOpenBlob) {
      window.navigator.msSaveOrOpenBlob(blob, fileName);
    } else {
      // Chromeなど
      let link = document.createElement('a');
      const objUrl = URL.createObjectURL(blob); // このオブジェクトURLを保存
      link.href = objUrl;
      link.download = fileName;
      link.click();
      setTimeout(() => {
        URL.revokeObjectURL(objUrl); // 保存したオブジェクトURLを解放
      }, 1e4);
    }
  };
});
