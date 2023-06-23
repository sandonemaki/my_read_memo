document.addEventListener('DOMContentLoaded', function () {
  const tabMenuItems = document.querySelectorAll('.tab__menu-item');
  const tabPanelItems = document.querySelectorAll('.tab__panel-box');

  function clearActiveStates() {
    tabMenuItems.forEach((item) => item.classList.remove('is-active'));
    tabPanelItems.forEach((item) => item.classList.remove('is-show'));
  }

  function tabSwitch(e) {
    clearActiveStates();
    const tabTargetData = e.currentTarget.dataset.tab;

    e.currentTarget.classList.add('is-active');
    document.querySelector(`.tab__panel-box[data-panel="${tabTargetData}"]`).classList.add('is-show');
  }

  tabMenuItems.forEach((tabMenuItem) => {
    tabMenuItem.addEventListener('click', tabSwitch);
  });
});
