import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";

export default class extends Controller {
  connect() {
    flatpickr(this.element, {
      enableTime: true,
      noCalendar: false,
      dateFormat: "Y-m-d H:00",
      time_24hr: true,
      minuteIncrement: 60 // 分を60分刻みにする（つまり00分のみ）
    });
  }
}
