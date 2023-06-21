document.addEventListener('DOMContentLoaded', function () {
  const onload = () => {
    const images = document.querySelectorAll('.sw_slide_img img');

    images.forEach((img) => {
      img.onload = () => {
        const aspectRatio = img.naturalWidth / img.naturalHeight;

        if (aspectRatio > 1) {
          img.style.width = '100%';
          img.style.height = 'auto';
        } else {
          img.style.width = 'auto';
          img.style.height = '100%';
        }
      };
      // 画像の読み込みが完了したら
      if (img.complete) img.onload();
    });
  };
  onload();
});
