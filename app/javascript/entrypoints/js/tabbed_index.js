document.addEventListener('DOMContentLoaded', function () {
  const tabMenuItems = document.querySelectorAll('.tab__menu-item.index-page');
  const underline_index = document.querySelector('#underline.index-page');
  const tabPanelItems = document.querySelectorAll('.tab__panel-box.index-page');
  const tabPanelBtns = document.querySelectorAll('.index_tab__panel-btn-js');

  function clearActiveStates() {
    tabMenuItems.forEach((item) => item.classList.remove('is-active'));
    tabPanelItems.forEach((item) => item.classList.remove('is-show'));
    tabPanelBtns.forEach((item) => item.classList.remove('is-show'));
  }

  function tabSwitch(e, index) {
    clearActiveStates();

    if (underline_index) {
      underline_index.style.left = `${index * 50}%`;
    }

    const tabTargetData = e.currentTarget.dataset.tab;

    e.currentTarget.classList.add('is-active');
    const panelToShow = document.querySelector(`.tab__panel-box[data-panel="${tabTargetData}"]`);
    const btnsToShow = document.querySelectorAll(`.index_tab__panel-btn-js[data-btn="${tabTargetData}"]`);

    if (panelToShow) panelToShow.classList.add('is-show');
    btnsToShow.forEach((btnToShow) => {
      if (btnToShow) btnToShow.classList.add('is-show');
    });
  }

  if (underline_index) {
    tabMenuItems.forEach((item, index) => {
      item.addEventListener('click', function (e) {
        tabSwitch(e, index);
      });
    });
  }

  // Initial underline position based on active class
  const initialActiveTab = document.querySelector('.tab__menu-item.index-page.is-active');

  if (underline_index && initialActiveTab) {
    const initialActiveIndex = initialActiveTab.dataset.tab - 1;
    underline_index.style.left = `${initialActiveIndex * 50}%`;
  }
});
