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
