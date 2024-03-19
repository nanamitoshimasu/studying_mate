import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"]
 
editEnd(event) {
    event.preventDefault();
    const response = event.detail[0];

    if (response.success) {
      // 成功時の処理: モーダルを表示
      this.showModal(response.message);
    } else {
      // 失敗時の処理: エラーメッセージを表示
      this.showErrorMessages(response.errors);
    }
  }

  showModal(message) {
    alert(message); // 実際にはモーダル表示のコードに置き換える
  }

  showErrorMessages(errors) {
    // エラーメッセージを表示するコード
  }
}
