class Message < ApplicationRecord
  validates :content, presence: true
  # データ保存後にMessageBroadcastJobのperformメソッドを実行,引数はself
  after_create_commit { MessageBroadcastJob.perform_later self }

  belongs_to :user
  belongs_to :room
end
