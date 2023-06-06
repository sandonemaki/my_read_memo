document.addEventListener('DOMContentLoaded', function() {
  // book/newのタイトル
  const inputTitle = document.querySelector('#input_title');
  const titleValidError = document.querySelector('#title_valid_error');

  const isInputTitleLengthValid = (inputTitle, minLength = 0, maxLength = 20) => {
    return inputTitle.value.length >= minLength && inputTitle.value.length <= maxLength;
  }
  inputTitle.addEventListener('input', () => {
    if (isInputTitleLengthValid(inputTitle) === false) {
      titleValidError.textContent = 'タイトルは20文字以内で入力してください';
    } else {
      titleValidError.textContent = '';
    }
    checkValidation();
  });

});