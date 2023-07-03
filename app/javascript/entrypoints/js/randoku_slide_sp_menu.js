document.addEventListener('DOMContentLoaded', function () {
  const menuIcon = document.querySelector('.sp-hamburger-menu');
  const menu = document.querySelector('.sp-slide-menu-content');
  const modalBackground = document.querySelector('.modal-menu-background');
  const menuItems = document.querySelectorAll('#menu li');

  if (!menuIcon) {
    return;
  }

  menuIcon.addEventListener('click', function () {
    menu.style.transform = menu.style.transform == 'translateY(100%)' ? 'translateY(0)' : 'translateY(100%)';
    // 背景の表示・非表示を切り替え
    if (menu.style.transform == 'translateY(100%)') {
      console.log('modal show');
      modalBackground.classList.remove('show');
    } else {
      console.log('modal');
      modalBackground.classList.add('show');
    }
  });

  if (modalBackground !== null && menuItems.length > 0) {
    modalBackground.addEventListener('click', () => {
      // モーダルとメニューを閉じる
      menu.style.transform = 'translateY(100%)';
      modalBackground.classList.remove('show');
    });

    menuItems.forEach((item) => {
      item.addEventListener('click', () => {
        menu.style.transform = 'translateY(100%)';
        modalBackground.classList.remove('show');
      });
    });
  }
});
