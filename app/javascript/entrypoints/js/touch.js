document.addEventListener('DOMContentLoaded', function () {
  if (document.querySelector('.touchpoint')) {
    const touchpoints = document.querySelectorAll('.touchpoint');
    //const panzooms = document.querySelectorAll('.panzoom');
    // ユーザーがピンチ操作（2本の指で拡大縮小）を行っているかどうかを管理
    // touchstartイベントで2本以上のタッチがある場合にtrue、touchendイベントでfalse
    let isPinching = false;

    touchpoints.forEach((touchpoint) => {
      // タップでの表示・非表示
      touchpoint.addEventListener('touchstart', (e) => {
        if (e.touches.length === 1) {
          // シングルタップのみ
          toggleTapNoneJsDisplay();
        }
      });

      // 拡大縮小中の表示・非表示
      touchpoint.addEventListener('touchstart', (e) => {
        if (e.touches.length > 1) {
          // ピンチ操作開始
          isPinching = true;
          hideTapNoneJs();
        }
      });

      touchpoint.addEventListener('touchend', () => {
        if (isPinching) {
          // ピンチ操作終了
          isPinching = false;
          showTapNoneJs();
        }
      });

      touchpoint.addEventListener('touchmove', (e) => {
        if (!isPinching && e.touches.length > 1) {
          // ピンチ操作開始
          isPinching = true;
          hideTapNoneJs();
        }
      });
    });
  }
});
// tap-none-jsクラスの要素の表示を切り替える関数
const toggleTapNoneJsDisplay = () => {
  document.querySelectorAll('.tap-none-js').forEach((elem) => {
    elem.style.display = elem.style.display === 'none' ? '' : 'none';
  });
};

// tap-none-jsクラスの要素を非表示にする関数
const hideTapNoneJs = () => {
  document.querySelectorAll('.tap-none-js').forEach(function (elem) {
    elem.style.display = 'none';
  });
};

// tap-none-jsクラスの要素を表示する関数
const showTapNoneJs = () => {
  document.querySelectorAll('.tap-none-js').forEach(function (elem) {
    elem.style.display = '';
  });
};
