document.addEventListener('DOMContentLoaded', function () {
  const searchSelect = document.getElementById('search-select');

  if (searchSelect) {
    searchSelect.addEventListener('change', function () {
      this.form.submit();
    });
  }
});
