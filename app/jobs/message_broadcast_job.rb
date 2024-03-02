class MessageBroadcastJob < ApplicationJob
  queue_as :default
  
  # ブロードキャスト(一つのネットワークの中にあるすべてのホストに対してデータを送る。)
  def perform(message)
    ActionCable.server.broadcast("room_channel_#{message.room_id}", {message: render_message(message)})
  end
  
  # app/views/message/_message.html.erbを呼び出す。
  private
  def render_message(message)
    ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message })
  end
end
