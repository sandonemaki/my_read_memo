// panzoomの初期設定
export const initializePanzoom = (panzoomEl) => {
  if (window.innerWidth <= 768) return null;

  return panzoom(panzoomEl, {
    bounds: true,
    boundsPadding: 0.5, // Allow the image to overflow a little bit
    smoothScroll: true,
    maxZoom: 4,
    minZoom: 0.5,
    //initialZoom: 1,
  });
};
// zoom_in/out関数
export const zoomInOut = (panzoomEl, instance, isIn) => {
  const scale = 1 + 0.25 * (isIn ? 1 : -1);
  instance.zoomTo(panzoomEl.clientWidth / 2, panzoomEl.clientHeight / 2, scale);
};

// zoom_reset関数
export const zoomReset = (instance) => {
  if (window.innerWidth <= 768) return;

  // Reset the panzoom element to its initial position and scale
  instance.moveTo(0, 0);
  instance.zoomAbs(0, 0, 1); // 1 is the initial scale
};

// zoom in/out, reset関数をclick時、touchend時に呼び出す
export const setupZoomEvents = (panzoomEl, instance, zoomInEl, zoomOutEl, zoomResetEl) => {
  if (window.innerWidth <= 768) return;

  zoomInEl.addEventListener('click', (e) => {
    e.preventDefault();
    console.log('Zoom in button clicked');
    zoomInOut(panzoomEl, instance, true);
  });
  zoomInEl.addEventListener('touchend', () => zoomInOut(panzoomEl, instance, true));
  zoomOutEl.addEventListener('click', (e) => {
    e.preventDefault();
    zoomInOut(panzoomEl, instance, false);
  });
  zoomOutEl.addEventListener('touchend', () => zoomInOut(panzoomEl, instance, false));
  // リセット
  zoomResetEl.addEventListener('click', (e) => {
    e.preventDefault();
    zoomReset(instance);
  });
};

// 拡大率を表示する関数
export const outputZoomString = (instance, printZoomEl) => {
  if (window.innerWidth <= 768) return;

  const formatZoom = () => {
    // パーセンテージに変換
    let scalePercentage = instance.getTransform().scale * 100;
    scalePercentage = scalePercentage.toFixed(3);
    printZoomEl.innerText = `${scalePercentage}%`;
  };

  formatZoom();

  // zoomが変更されるたびにformatZoomを呼び出す
  instance.on('zoom', formatZoom);
};
