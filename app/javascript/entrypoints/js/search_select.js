document.addEventListener('DOMContentLoaded', function () {
  const searchSelect = document.getElementById('search-select');

  if (searchSelect) {
    searchSelect.addEventListener('change', function (event) {
      if (this.value === '0') {
        event.preventDefault(); // 送信キャンセル
      } else {
        this.form.submit();
      }
    });
  }
});
