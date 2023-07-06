document.addEventListener('DOMContentLoaded', function () {
  const tabMenuItems = document.querySelectorAll('.tab__menu-item');
  const underline = document.querySelector('#underline'); // 追加
  const tabPanelItems = document.querySelectorAll('.tab__panel-box');
  const tabPanelBtns = document.querySelectorAll('.index_tab__panel-btn-js');

  function clearActiveStates() {
    tabMenuItems.forEach((item) => item.classList.remove('is-active'));
    tabPanelItems.forEach((item) => item.classList.remove('is-show'));
    tabPanelBtns.forEach((item) => item.classList.remove('is-show'));
  }

  function tabSwitch(e, index) {
    clearActiveStates();
    underline.style.left = `${index * 33.33}%`;
    const tabTargetData = e.currentTarget.dataset.tab;

    e.currentTarget.classList.add('is-active');
    const panelToShow = document.querySelector(`.tab__panel-box[data-panel="${tabTargetData}"]`);
    const btnsToShow = document.querySelectorAll(`.index_tab__panel-btn-js[data-btn="${tabTargetData}"]`);

    if (panelToShow) panelToShow.classList.add('is-show');
    btnsToShow.forEach((btnToShow) => {
      if (tnToShow) tnToShow.classList.add('is-show');
    });
  }

  tabMenuItems.forEach((item, index) => {
    item.addEventListener('click', function (e) {
      tabSwitch(e, index);
    });
  });
});
