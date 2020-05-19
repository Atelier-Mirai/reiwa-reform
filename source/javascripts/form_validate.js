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

// 参照元URLをセット
document.getElementById("referrer_url").value = document.referrer;

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
