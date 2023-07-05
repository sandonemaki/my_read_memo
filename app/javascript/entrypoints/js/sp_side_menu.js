document.addEventListener('DOMContentLoaded', (event) => {
  const openSlideMenuList = document.querySelectorAll('.open-slide-menu-js');
  openSlideMenuList.forEach((menu) => {
    menu.addEventListener('click', function () {
      const header = document.querySelector('#header-content-js');
      const mains = document.querySelectorAll('.main-content-js');
      const globalSlider = document.querySelector('#global-sidebar');
      if (header.style.transform === 'translate(-280px)') {
        header.style.transform = 'translate(0px)';
        mains.forEach((main) => {
          main.style.transform = 'translate(0px)';
        });
        //globalSlider.style.opacity = '0';
        //globalSlider.style.visibility = 'hidden';
        globalSlider.style.zIndex = -100;
      } else {
        header.style.transform = 'translate(-280px)';
        mains.forEach((main) => {
          main.style.transform = 'translate(-280px)';
        });
        globalSlider.style.opacity = '1';
        globalSlider.style.visibility = 'visible';
        globalSlider.style.zIndex = 10000;
      }
    });
  });
});
