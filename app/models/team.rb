class Team < ApplicationRecord
  validates :target_time, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :capacity, presence: true

  belongs_to :usera

  def full?
    user.count >= capacity
end
