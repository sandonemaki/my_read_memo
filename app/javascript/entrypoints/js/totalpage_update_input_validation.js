document.addEventListener('DOMContentLoaded', function () {
  const slideTotalPageSubmit = document.querySelector('#total_page_submit_btn_js');
  const slideInputTotalPage = document.querySelector('#input_total_page_slide_js');
  const totalPageValidError = document.querySelector('#total_page_valid_error_slide');

  if (slideTotalPageSubmit && slideInputTotalPage && totalPageValidError) {
    const isInputTotalPageValid = (slideInputTotalPage, minNum = 20, maxNum = 999) => {
      const inputValue = Number(slideInputTotalPage.value);
      return inputValue >= minNum && inputValue <= maxNum && Number.isInteger(inputValue);
    };

    const CheckTotalPageValidation = () => {
      if (isInputTotalPageValid(slideInputTotalPage) === false) {
        slideTotalPageSubmit.disabled = true;
      } else {
        slideTotalPageSubmit.disabled = false;
      }
    };

    slideInputTotalPage.addEventListener('input', () => {
      const isValid = isInputTotalPageValid(slideInputTotalPage);
      console.log('checkValidation called, isValid:', isValid);
      if (isValid === false) {
        totalPageValidError.textContent = '20から999の整数を入力してください';
      } else {
        totalPageValidError.textContent = '';
      }
      CheckTotalPageValidation();
    });

    // 最初のチェックを行う
    CheckTotalPageValidation();
  }
});
