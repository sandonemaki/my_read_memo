// フラッシュ notice メッセージの要素を取得
const flashMessage_notice = document.querySelector('.c-flash--notice');
export const js_flash = (message) => {
  // メッセージを設定
  setFlashMessage({ flashElement: flashMessage_notice, message: message });
  // メッセージを表示
  showFlashMessage({ flashElement: flashMessage_notice });
  // 一定時間後にメッセージを非表示にする
  setTimeout(() => hideFlashMessage({ flashElement: flashMessage_notice }), 4500); // 4500ミリ秒（4.5秒）後に実行する
}


// フラッシュ alert メッセージの要素を取得
const flashMessage_alert = document.querySelector('.c-flash--alert');
export const js_flash_alert = (message) => {
  // メッセージを設定
  setFlashMessage({ flashElement: flashMessage_alert, message: message });
  // メッセージを表示
  showFlashMessage({ flashElement: flashMessage_alert });
  // X ボタンで非表示
  closeFlash();
}
// application.html.erbから呼び出すため関数をグローバルスコープに公開する
window.js_flash_alert = js_flash_alert;


// メッセージを設定する関数
const setFlashMessage = ({ flashElement, message }) => {
  flashElement.querySelector('.c-flash-text').textContent = message;
}

// メッセージを表示する関数
const showFlashMessage = ({ flashElement }) => {
  flashElement.style.right = '10px';  // 右端から10pxの位置に移動する
  flashElement.style.opacity = '1';  // 不透明にする
}

// メッセージを非表示にする関数
const hideFlashMessage = ({ flashElement }) => {
  flashElement.style.right = '-1000px';  // 元の位置に戻す
  flashElement.style.opacity = '0';  // 透明にする
}

/// メッセージを即座に非表示にする関数
const closeFlash = () => {
  const closeFlashElement = document.querySelector('#close-flash');
  closeFlashElement.addEventListener('click', (event) => {
    flashMessage_alert.style.right = '-1000px';
    flashMessage_alert.style.opacity = '0';
  });
}

// window.addEventListener('DOMContentLoaded', closeFlash);