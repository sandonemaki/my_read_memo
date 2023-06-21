document.addEventListener('DOMContentLoaded', function () {
  const memoContentSubmit = document.querySelector('.memo-submit-button');

  const checkValidation = () => {
    if (isInputMemoLengthValid(inputMemo) === false) {
      memoContentSubmit.disabled = true;
    } else {
      memoContentSubmit.disabled = false;
    }
  };

  // randoku_memos/newのcontent
  // seidoku_memos/newのcontent
  const inputMemo = document.querySelector('.memo-input-textarea');
  const memoValidError = document.querySelector('#memo_valid_error');

  const isInputMemoLengthValid = (inputMemo, minLength = 0) => {
    return inputMemo.value.length > minLength;
  };

  inputMemo.addEventListener('input', () => {
    // if (isInputMemoLengthValid(inputMemo) === false) {
    //   memoValidError.textContent = '';
    // } else {
    //   memoValidError.textContent = '';
    // }
    checkValidation();
  });
});
