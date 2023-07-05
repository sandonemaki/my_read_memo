document.addEventListener('DOMContentLoaded', (event) => {
  const openSlideMenuList = document.querySelectorAll('.open-slide-menu-js');
  openSlideMenuList.forEach((menu) => {
    menu.addEventListener('click', function () {
      const header = document.querySelector('#header-content-js');
      const main = document.querySelector('#main-background');
      const globalSlider = document.querySelector('#global-sidebar'); // querySelectorAllをquerySelectorに変更
      if (header.style.transform === 'translate(-280px)' && main.style.transform === 'translate(-280px)') {
        header.style.transform = 'translate(0px)';
        main.style.transform = 'translate(0px)';
        //globalSlider.style.opacity = '0';
        //globalSlider.style.visibility = 'hidden';
        //globalSlider.style.zIndex = -100;
      } else {
        header.style.transform = 'translate(-280px)';
        main.style.transform = 'translate(-280px)';
        globalSlider.style.opacity = '1';
        globalSlider.style.visibility = 'visible';
      }
    });
  });
});
