document.addEventListener('DOMContentLoaded', function () {
  const bookInfoSubmit = document.querySelector('.book-info-submit-js');
  const inputTitle = document.querySelector('#input_title');
  const titleValidError = document.querySelector('#title_valid_error');
  const inputAuthor = document.querySelector('#input_author');
  const authorValidError = document.querySelector('#author_valid_error');
  const inputPublisher = document.querySelector('#input_publisher');
  const publisherValidError = document.querySelector('#publisher_valid_error');
  const inputTotalPage = document.querySelector('#input_total_page');
  const totalPageValidError = document.querySelector('#total_page_valid_error');

  // 初期値を取得
  const initialTitleValue = inputTitle?.value || '';
  const initialAuthorValue = inputAuthor?.value || '';
  const initialTotalPageValue = inputTotalPage?.value || '';
  const initialInputPublisherValue = inputPublisher?.value || '';

  // 編集ページかどうかを確認
  const isEditPage = document.querySelector('.edit') ? true : false;

  // 初期状態で編集ページならボタンを無効化
  if (bookInfoSubmit) {
    if (isEditPage) {
      bookInfoSubmit.disabled = true;
    } else {
      bookInfoSubmit.disabled = false;
    }
  }

  if (
    bookInfoSubmit &&
    inputTitle &&
    titleValidError &&
    inputAuthor &&
    authorValidError &&
    inputPublisher &&
    publisherValidError &&
    inputTotalPage &&
    totalPageValidError
  ) {
    const checkValidation = () => {
      if (
        isInputTotalPageValid(inputTotalPage) &&
        isInputTitleLengthValid(inputTitle) &&
        isInputAuthorLengthValid(inputAuthor) &&
        isInputPublisherLengthValid(inputPublisher)
      ) {
        bookInfoSubmit.disabled = false;
      } else {
        bookInfoSubmit.disabled = true;
      }
    };

    const isInputTitleLengthValid = (inputTitle, minLength = 0, maxLength = 20) => {
      return inputTitle.value.length >= minLength && inputTitle.value.length <= maxLength;
    };

    const isInputAuthorLengthValid = (inputAuthor, minLength = 0, maxLength = 20) => {
      return inputAuthor.value.length >= minLength && inputAuthor.value.length <= maxLength;
    };
    const isInputPublisherLengthValid = (inputPublisher, minLength = 0, maxLength = 20) => {
      return inputPublisher.value.length >= minLength && inputPublisher.value.length <= maxLength;
    };

    const isInputTotalPageValid = (inputTotalPage, minNum = 20, maxNum = 999) => {
      const inputValue = Number(inputTotalPage.value);
      return inputValue >= minNum && inputValue <= maxNum && Number.isInteger(inputValue);
    };

    [inputTitle, inputAuthor, inputTotalPage, inputPublisher].forEach((input) => {
      input.addEventListener('input', () => {
        // タイトルのバリデーション
        if (input === inputTitle) {
          titleValidError.textContent = isInputTitleLengthValid(inputTitle)
            ? ''
            : 'タイトルは20文字以内で入力してください';
        }

        // 著者名のバリデーション
        if (input === inputAuthor) {
          authorValidError.textContent = isInputAuthorLengthValid(inputAuthor)
            ? ''
            : '著者名は20文字以内で入力してください';
        }

        // 著者名のバリデーション
        if (input === inputPublisher) {
          publisherValidError.textContent = isInputPublisherLengthValid(inputPublisher)
            ? ''
            : '出版社は20文字以内で入力してください';
        }

        // トータルページのバリデーション
        if (input === inputTotalPage) {
          totalPageValidError.textContent = isInputTotalPageValid(inputTotalPage)
            ? ''
            : '20から999の整数を入力してください';
        }

        // 入力が変更されたかどうか
        const isValueChanged =
          initialTitleValue !== inputTitle.value ||
          initialAuthorValue !== inputAuthor.value ||
          initialInputPublisherValue !== inputPublisher.value ||
          initialTotalPageValue !== inputTotalPage.value;

        // 編集ページで入力が変わっている場合、ボタンを有効化
        if (isEditPage && isValueChanged) {
          bookInfoSubmit.disabled = false;
        }

        // 全てのバリデーションをチェック
        checkValidation();
      });
    });
  }
});
