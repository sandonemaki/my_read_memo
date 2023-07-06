document.addEventListener('DOMContentLoaded', function () {
  const tabMenuItems = document.querySelectorAll('.tab__menu-item');
  const underline_show = document.querySelector('#underline.show-page');
  const underline_index = document.querySelector('#underline.index-page');
  const tabPanelItems = document.querySelectorAll('.tab__panel-box');
  const tabPanelBtns = document.querySelectorAll('.index_tab__panel-btn-js');

  function clearActiveStates() {
    tabMenuItems.forEach((item) => item.classList.remove('is-active'));
    tabPanelItems.forEach((item) => item.classList.remove('is-show'));
    tabPanelBtns.forEach((item) => item.classList.remove('is-show'));
  }

  function tabSwitch(e, index) {
    clearActiveStates();

    let underline;
    let underline_length;

    if (underline_show) {
      underline_length = 33.33;
      underline = underline_show;
    } else if (underline_index) {
      underline_length = 50.0;
      underline = underline_index;
    } else return;

    if (underline) {
      underline.style.left = `${index * underline_length}%`;
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

  tabMenuItems.forEach((item, index) => {
    item.addEventListener('click', function (e) {
      tabSwitch(e, index);
    });
  });
});
