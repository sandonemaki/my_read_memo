document.addEventListener('DOMContentLoaded', function () {
  const bookInfoSubmit = document.querySelector('.book-info-submit-js');
  const inputTitle = document.querySelector('#input_title');
  const titleValidError = document.querySelector('#title_valid_error');
  const inputAuthor = document.querySelector('#input_author');
  const authorValidError = document.querySelector('#author_valid_error');
  const inputTotalPage = document.querySelector('#input_total_page');
  const totalPageValidError = document.querySelector('#total_page_valid_error');

  // すべての必要な要素が存在するか確認する
  if (
    bookInfoSubmit &&
    inputTitle &&
    titleValidError &&
    inputAuthor &&
    authorValidError &&
    inputTotalPage &&
    totalPageValidError
  ) {
    const checkValidation = () => {
      if (
        isInputTotalPageValid(inputTotalPage) === false ||
        isInputTitleLengthValid(inputTitle) === false ||
        isInputAuthorLengthValid(inputAuthor) === false
      ) {
        bookInfoSubmit.disabled = true;
      } else {
        bookInfoSubmit.disabled = false;
      }
    };

    // book/newのタイトル
    const isInputTitleLengthValid = (inputTitle, minLength = 0, maxLength = 20) => {
      if (inputTitle) {
        return inputTitle.value.length >= minLength && inputTitle.value.length <= maxLength;
      }
    };
    if (inputTitle) {
      inputTitle.addEventListener('input', () => {
        if (isInputTitleLengthValid(inputTitle) === false) {
          titleValidError.textContent = 'タイトルは20文字以内で入力してください';
        } else {
          titleValidError.textContent = '';
        }
        checkValidation();
      });
    }

    // book/newの著者名
    const isInputAuthorLengthValid = (inputAuthor, minLength = 0, maxLength = 20) => {
      if (inputAuthor) {
        return inputAuthor.value.length >= minLength && inputAuthor.value.length <= maxLength;
      }
    };

    if (inputAuthor) {
      inputAuthor.addEventListener('input', () => {
        if (isInputAuthorLengthValid(inputAuthor) === false) {
          authorValidError.textContent = '著者名は20文字以内で入力してください';
        } else {
          authorValidError.textContent = '';
        }
        checkValidation();
      });
    }

    // book/newのトータルページ
    const isInputTotalPageValid = (inputTotalPage, minNum = 20, maxNum = 999) => {
      if (inputTotalPage) {
        const inputValue = Number(inputTotalPage.value);
        return inputValue >= minNum && inputValue <= maxNum && Number.isInteger(inputValue);
      }
    };

    if (inputTotalPage) {
      inputTotalPage.addEventListener('input', () => {
        if (isInputTotalPageValid(inputTotalPage) === false) {
          totalPageValidError.textContent = '20から999の整数を入力してください';
        } else {
          totalPageValidError.textContent = '';
        }
        checkValidation();
      });
    }
  }
});
