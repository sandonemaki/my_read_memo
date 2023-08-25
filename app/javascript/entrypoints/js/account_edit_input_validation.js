document.addEventListener('DOMContentLoaded', function () {
  const accountSettingSubmit = document.querySelector('.account-setting-submit-js');
  const inputNickname = document.querySelector('#input_nickname');
  const nicknameValidError = document.querySelector('#nickname_valid_error');
  const inputEmail = document.querySelector('#input_email');
  const emailValidError = document.querySelector('#email_valid_error');

  // 初期値を取得
  const initialNicknameValue = inputNickname?.value || '';
  const initialEmailValue = inputEmail?.value || '';

  // 編集ページかどうかを確認
  const isAccountSettingPage = document.querySelector('.account-setting') ? true : false;

  // 初期状態で編集ページならボタンを無効化
  if (accountSettingSubmit) {
    if (isAccountSettingPage) {
      accountSettingSubmit.disabled = true;
    } else {
      accountSettingSubmit.disabled = false;
    }
  }

  if (accountSettingSubmit && inputNickname && nicknameValidError && inputEmail && emailValidError) {
    const checkValidation = () => {
      if (isInputNicknameValid(inputNickname) && isInputEmailValid(inputEmail)) {
        accountSettingSubmit.disabled = false;
      } else {
        accountSettingSubmit.disabled = true;
      }
    };

    const isInputNicknameValid = (inputNickname, minLength = 0, maxLength = 13) => {
      return inputNickname.value.length >= minLength && inputNickname.value.length <= maxLength;
    };

    const isInputEmailValid = (inputEmail) => {
      const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      return re.test(String(inputEmail.value).toLowerCase());
    };

    [inputNickname, inputEmail].forEach((input) => {
      input.addEventListener('input', () => {
        // ニックネームのバリデーション
        if (input === inputNickname) {
          nicknameValidError.textContent = isInputNicknameValid(inputNickname)
            ? ''
            : 'ニックネームは13文字以内で入力してください';
        }

        // emailのバリデーション
        if (input === inputEmail) {
          emailValidError.textContent = isInputEmailValid(inputEmail)
            ? ''
            : '無効なEメールアドレスです。正しい形式で入力してください';
        }

        // 入力が変更されたかどうか
        const isValueChanged = initialNicknameValue !== inputNickname.value || initialEmailValue !== inputEmail.value;

        // アカウントセッティングページで入力が変わっている場合、ボタンを有効化
        if (isAccountSettingPage && isValueChanged) {
          accountSettingSubmit.disabled = false;
        }

        // 全てのバリデーションをチェック
        checkValidation();
      });
    });
  }
});
