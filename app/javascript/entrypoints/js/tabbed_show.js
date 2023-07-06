document.addEventListener('DOMContentLoaded', function () {
  const tabMenuItems = document.querySelectorAll('.tab__menu-item.show-page');
  const underline_show = document.querySelector('#underline.show-page');
  const tabPanelItems = document.querySelectorAll('.tab__panel-box.show-page');

  function clearActiveStates() {
    tabMenuItems.forEach((item) => item.classList.remove('is-active'));
    tabPanelItems.forEach((item) => item.classList.remove('is-show'));
  }

  function tabSwitch(e, index) {
    clearActiveStates();

    if (underline_show) {
      underline_show.style.left = `${index * 33.33}%`;
    }

    const tabTargetData = e.currentTarget.dataset.tab;

    e.currentTarget.classList.add('is-active');
    const panelToShow = document.querySelector(`.tab__panel-box[data-panel="${tabTargetData}"]`);

    if (panelToShow) panelToShow.classList.add('is-show');
  }

  if (underline_show) {
    tabMenuItems.forEach((item, index) => {
      item.addEventListener('click', function (e) {
        tabSwitch(e, index);
      });
    });
  }
});
