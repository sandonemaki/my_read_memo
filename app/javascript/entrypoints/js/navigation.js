document.addEventListener('DOMContentLoaded', function () {
  const naviTriggerBtns = document.querySelectorAll('.navi-trigger-btn-js');
  const naviPanels = document.querySelectorAll('.navi-panel-js');

  // naviTriggerBtnボタンをクリックしたときの処理
  naviTriggerBtns.forEach((naviTriggerBtn, i) => {
    naviTriggerBtn.addEventListener('click', (e) => {
      e.stopPropagation(); // windowまで伝播しない
      const naviPanel = naviPanels[i];

      if (naviPanel.classList.contains('active')) {
        // クリックしたボタンに対応するパネルを閉じる
        naviPanel.classList.remove('active');
      } else {
        // 全てのpanelを閉じてからクリックしたボタンに対応するpanelをactive
        closeNaviPanles();
        naviPanel.classList.add('active');
      }
    });
  });
});
