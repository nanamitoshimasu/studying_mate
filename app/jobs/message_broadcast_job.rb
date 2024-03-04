class MessageBroadcastJob < ApplicationJob
  queue_as :default
  
  # ブロードキャスト(一つのネットワークの中にあるすべてのホストに対してデータを送る。)
  def perform(message)
    avatar_url = message.user.avatar.url
    ActionCable.server.broadcast("room_channel_#{message.room_id}", {
      message: render_message(message),
      user_id: message.user_id,
      user_name: message.user.name,
      user_avatar: avatar_url,
      formatted_created_at: message.created_at.strftime('%H:%M')
    })
    
  end
  
  # app/views/message/_message.html.erbを呼び出す。
  private
  def render_message(message)
    ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message })
  end
end
