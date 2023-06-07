import { getCsrfToken } from './get_csrf_token.js';
import { js_flash_alert } from './flash.js';

document.addEventListener('DOMContentLoaded', function() {

  const downloadBtns = document.querySelectorAll(".download-btn");

  downloadBtns.forEach(download_btn => {
    download_btn.addEventListener('click', async () => {
      await downloadImg(download_btn)
    });
  });

}