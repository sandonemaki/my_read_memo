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


  // book/newの著者名
  const inputAuthor = document.querySelector('#input_author');
  const authorValidError = document.querySelector('#author_valid_error');

  const isInputAuthorLengthValid = (inputAuthor, minLength = 0, maxLength = 20) => {
    return inputAuthor.value.length >= minLength && inputAuthor.value.length <= maxLength;
  }

  inputAuthor.addEventListener('input', () => {
    if (isInputAuthorLengthValid(inputAuthor) === false) {
      authorValidError.textContent = '著者名は20文字以内で入力してください';
    } else {
      authorValidError.textContent = '';
    }
    checkValidation();
  })
});