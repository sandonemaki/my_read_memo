export const js_flash = ({ flashMessage, input_message }) => {
  // メッセージを設定
  setFlashMessage(flashMessage, input_message);
  // メッセージを表示
  showFlashMessage(flashMessage);
  // 一定時間後にメッセージを非表示にする
  setTimeout(() => hideFlashMessage(flashMessage), 4500); // 4500ミリ秒（4.5秒）後に実行する
}

// メッセージを設定する関数
const setFlashMessage = (flashMessage, message) => {
    flashMessage.querySelector('.c-flash-text').textContent = message;
}

// メッセージを表示する関数
const showFlashMessage = (flashMessage) => {
    flashMessage.style.right = '10px';  // 右端から10pxの位置に移動する
    flashMessage.style.opacity = '1';  // 不透明にする
}

// メッセージを非表示にする関数
const hideFlashMessage = (flashMessage) => {
    flashMessage.style.right = '-1000px';  // 元の位置に戻す
    flashMessage.style.opacity = '0';  // 透明にする
}