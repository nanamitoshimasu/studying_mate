import consumer from "./consumer"

document.addEventListener('DOMContentLoaded', () =>{
  const currentUserID = document.body.getAttribute('data-current-user-id');
  const messages = document.getElementById('messages');
  const roomId = messages.getAttribute('data-room-id');

  const chatChannel = consumer.subscriptions.create({ channel: "RoomChannel", room: roomId }, {
    connected() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      const isCurrentUser = data.user_id.toString() === currentUserID;
      const messageClass = isCurrentUser ? `chat chat-end` : `chat chat-start`;
      const messagesElement = `
        <div class="${messageClass}">
          <div class="chat-image avatar">
            <div class="w-10 rounded-full">
              <img src="${data.user_avatar}" />
            </div>
          </div>
          <div class="chat-header">
            ${data.user_name}
            <time class="text-xs opacity-50">${data.formatted_created_at}</time>
          </div>
          <div class="chat-bubble">${data.content}</div>
        </div>
      `;
      messages.insertAdjacentHTML('beforeend', messagesElement);
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
