document.addEventListener('DOMContentLoaded', function () {
  // 画像の選択が完了するまで upload できない
  const uploadInput = document.querySelector('#upload');
  const submitBtn = document.querySelector('#submit-btn');

  if (uploadInput) {
    uploadInput.addEventListener('change', function () {
      if (this.files.length) {
        submitBtn.disabled = false;
      } else {
        submitBtn.disabled = true;
      }
    });
  }
});
