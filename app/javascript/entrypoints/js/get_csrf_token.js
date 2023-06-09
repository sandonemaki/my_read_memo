export const getCsrfToken = () => {
  const metalist = document.getElementsByTagName('meta');
  for (let meta of metalist) {
    if (meta.getAttribute('name') === 'csrf-token') {
      return meta.getAttribute('content');
    }
  }
  alert('エラーが発生しました: CSRF token metatag が見つかりません。 ページを更新して、もう一度お試しください');
  throw new Error('CSRF token meta tag not found');
};
