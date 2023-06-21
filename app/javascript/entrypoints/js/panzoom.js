// panzoomの初期設定
export const initializePanzoom = (panzoomEl) => {
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
