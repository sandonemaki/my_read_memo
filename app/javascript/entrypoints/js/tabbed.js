document.addEventListener('DOMContentLoaded', function () {
  const tabMenuItems = document.querySelectorAll('.tab__menu-item');
  const tabPanelItems = document.querySelectorAll('.tab__panel-box');
  const tabPanelBtns = document.querySelectorAll('.tab__panel-btn');

  function clearActiveStates() {
    tabMenuItems.forEach((item) => item.classList.remove('is-active'));
    tabPanelItems.forEach((item) => item.classList.remove('is-show'));
    tabPanelBtns.forEach((item) => item.classList.remove('is-show'));
  }

  function tabSwitch(e) {
    clearActiveStates();
    const tabTargetData = e.currentTarget.dataset.tab;

    e.currentTarget.classList.add('is-active');
    const panel = document.querySelector(`.tab__panel-box[data-panel="${tabTargetData}"]`);
    const btn = document.querySelector(`.tab__panel-btn[data-btn="${tabTargetData}"]`);

    if (panel) panel.classList.add('is-show');
    if (btn) btn.classList.add('is-show');
  }

  tabMenuItems.forEach((tabMenuItem) => {
    tabMenuItem.addEventListener('click', tabSwitch);
  });
});
