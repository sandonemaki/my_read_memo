document.addEventListener('DOMContentLoaded', function () {
  const searchSelect = document.getElementById('search-select');

  searchSelect.addEventListener('change', function () {
    this.form.submit();
  });
});
