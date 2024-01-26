import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "display"]

  display() {
    console.log("displayメソッドが呼び出された");
    const selectedValue = this.selectTarget.value
    console.log("選択された値:", selectedValue);
    const imageUrl = this.getImageUrlFor(selectedValue)
    console.log("取得した画像のURL:", imageUrl);
    this.displayTarget.src = imageUrl
  }

  getImageUrlFor(selectedValue) {
    // console.log("受け取った値:", value);
    // const stringValue = selectedValue.toString(); // 数値を文字列に変換
    // console.log("文字列に変換した値:", stringValue);

    if (["10", "20"].includes(selectedValue)) {
      return '/assets/image-1.jpg';
    } else if (["30", "40"].includes(selectedValue)) {
      return '/assets/image-2.jpg';
    } else if (["50", "60"].includes(selectedValue)) {
      return '/assets/image-3.jpg';
    } else if (["70", "80"].includes(selectedValue)) {
      return '/assets/image-4.jpg';
    } else if (["90", "100"].includes(selectedValue)) {
      return '/assets/image-5.jpg';
    } else if (["110", "120"].includes(selectedValue)) {
      return '/assets/image-6.jpg';
    } else if (["130", "140"].includes(selectedValue)) {
      return '/assets/image-7.jpg';
    } else if (["150", "160"].includes(selectedValue)) {
      return '/assets/image-8.jpg';
    } else if (["170", "180"].includes(selectedValue)) {
      return '/assets/image-9.jpg';
    } else if (["190", "200"].includes(selectedValue)) {
      return '/assets/image-10.jpg';
    } else if (["210", "220"].includes(selectedValue)) {
      return '/assets/image-11.jpg';
    } else if (["230", "240"].includes(selectedValue)) {
      return '/assets/image-12.jpg';
    } else if (["250", "260"].includes(selectedValue)) {
      return '/assets/image-13.jpg';
    } else if (["270", "280"].includes(selectedValue)) {
      return '/assets/image-14.jpg';
    } else if (["290", "300"].includes(selectedValue)) {
      return '/assets/image-15.jpg';
    } else if (["310", "320"].includes(selectedValue)) {
      return '/assets/image-16.jpg';
    } else if (["330", "340"].includes(selectedValue)) {
      return '/assets/image-17.jpg';
    } else if (["350", "360"].includes(selectedValue)) {
      return '/assets/image-18.jpg';
    } else if (["370", "380"].includes(selectedValue)) {
      return '/assets/image-19.jpg';
    } else  (["390", "400"].includes(selectedValue)); {
      return '/assets/image-20.jpg';
    }
  }
}
