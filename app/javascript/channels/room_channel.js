import consumer from "./consumer"

const chatChannel = consumer.subscriptions.create("RoomChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
   const messages = document.getElementById('messages');
   messages.insertAdjacentHTML('beforeend', data['message']);
  },

  speak: function(message) {
    return this.perform('speak', {message: message});
  }
});

// フォーム内でEnterキーが押された時の動作を記述
// Vanilla JavaScriptで実装
document.addEventListener('DOMContentLoaded', () => {
  const inputElement = document.querySelector('.input');
  inputElement.addEventListener('keydown', event => {
    const element = event.target;
    const isRoomSpeaker = element.matches('[data-behavior~=room_speaker]');

    if (event.key === 'Enter' && isRoomSpeaker) {
      chatChannel.speak(event.target.value);
      event.target.value = '';
      event.preventDefault();
    }
  });
});
