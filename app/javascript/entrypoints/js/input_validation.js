document.addEventListener('DOMContentLoaded', function() {

  const bookInfoSubmit = document.querySelector('#book_info_submit');
  const checkValidation = () => {
    if (
      isInputTotalPageValid(inputTotalPage) === false
      || isInputTitleLengthValid(inputTitle) === false
      || isInputAuthorLengthValid(inputAuthor) === false
    ) {
      bookInfoSubmit.disabled = true;
    } else {
      bookInfoSubmit.disabled = false;
    }
  }


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


  // book/newのトータルページ
  const inputTotalPage = document.querySelector('#input_total_page');
  const totalPageValidError = document.querySelector('#total_page_valid_error');

  const isInputTotalPageValid = (inputTotalPage, minNum = 20, maxNum = 999) => {
    const inputValue = Number(inputTotalPage.value);
    return inputValue >= minNum && inputValue <= maxNum && Number.isInteger(inputValue);
  }

  inputTotalPage.addEventListener('input', () => {
    if (isInputTotalPageValid(inputTotalPage) === false) {
      totalPageValidError.textContent = '20から999の整数を入力してください';
    } else {
      totalPageValidError.textContent = '';
    }
    checkValidation();
  });
});