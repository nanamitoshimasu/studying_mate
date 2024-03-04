class Room < ApplicationRecord
  has_many :messages, dependent: :destroy
  belongs_to :team
end
