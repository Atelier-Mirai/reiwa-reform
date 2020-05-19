/*=============================================================================
  問い合わせフォーム用 JavaScript
=============================================================================*/

/*-----------------------------------------------------------------------------
  CSS疑似クラスを活用した、モダンでインタラクティブなフォームの作り方
  https://ics.media/entry/200413/
-----------------------------------------------------------------------------*/
// フォーム全体の妥当性をチェック
const validate = () => {
  const validForm = document.querySelector("form:valid");
  // const submitButton = document.querySelector("#submit");
  // こちらも等価
  const submitButton = document.getElementById("submit")
  submitButton.disabled = (validForm === null);
};

// 初期読み込み時に実行
validate();

// フォームに入力されたら、validate関数を実行
document.querySelectorAll("input,textarea").forEach(input => {
  input.addEventListener("input", validate);
});

/*-----------------------------------------------------------------------------
  どの施工例を見てからの問い合わせか分かるよう、
  参照元URLをセット
-----------------------------------------------------------------------------*/
document.getElementById("referrer_url").value = document.referrer;

/*-----------------------------------------------------------------------------
  【JavaScript】ページ離脱時に beforeunload でアラート表示
  https://qiita.com/naoki_koreeda/items/bf0f512dbd91b450c671
-----------------------------------------------------------------------------*/
// フォーム送信前にタブを閉じる際に、確認アラートを表示する。
const confirmation_aleat = function (e) {
    // カスタムメッセージの設定（IE/Edgeのみ有効)
    const confirmMessage = '入力欄を破棄し、離脱します。よろしいですか？';
    e.returnValue = confirmMessage;
    return confirmMessage;
};

// beforeunloadイベントの登録
window.addEventListener('beforeunload', confirmation_aleat, false);

// submit ボタンが押されたときには、離脱アラートを表示しない。
document.getElementById('submit').addEventListener('click', () => {
    // submit時はアラート表示させない
    window.removeEventListener('beforeunload', confirmation_aleat, false);
});
