import consumer from "./consumer"

document.addEventListener('turbo:load', () =>{
  const messages = document.getElementById('messages');
  if (!messages) return; // messages が存在しない場合はここで処理を終了
  const currentUserId = parseInt(messages.getAttribute('data-current-user-id'));
  const roomId = messages.getAttribute('data-room-id');

  const chatChannel = consumer.subscriptions.create({ channel: "RoomChannel", room: roomId }, {
    connected() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      const isCurrentUser = data.user_id === currentUserId;
      const messageClass = isCurrentUser ? `chat chat-end mr-2` : `chat chat-start ml-2`;

      // メッセージの内容を追加
      const messageElement = `
        <div class="${messageClass}">
          <div class="chat-image avatar">
            <div class="w-10 rounded-full">
              <img src="${data.user_avatar}">
            </div>
          </div>
          <div class="chat-header">
            ${data.user_name}
            <time class="text-xs opacity-50">${data.formatted_created_at}</time>
          </div>
          <div class="chat-bubble chat-bubble-success body">${data.message_content}</div>
        </div>
      `;

      // メッセージ要素をチャットエリアに追加
      messages.insertAdjacentHTML('beforeend', messageElement);
      messages.scrollTop = messages.scrollHeight;
    },

    speak: function(message) {
      return this.perform('speak', {message: message});
    }
  }); 

  const inputElement = document.querySelector('.input');
  const sendMessageButton = document.getElementById('send-message');

  sendMessageButton.addEventListener('click', event => {
    const messageValue = inputElement.value;
    if (messageValue.trim() !== '') {
      chatChannel.speak(messageValue);
      inputElement.value = '';
    }
  });
});
