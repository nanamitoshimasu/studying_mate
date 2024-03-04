class MessageBroadcastJob < ApplicationJob
  queue_as :default
  
  # ブロードキャスト(一つのネットワークの中にあるすべてのホストに対してデータを送る。)
  def perform(message)
    ActionCable.server.broadcast("room_channel_#{message.room_id}", {
      user_id: message.user_id,
      user_avatar: message.user.avatar.url,
      user_name: message.user.name,
      formatted_created_at: message.created_at.strftime('%H:%M'),
      message_content: message.content
    })
  end
 end
