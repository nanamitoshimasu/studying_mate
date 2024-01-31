class Timer < ApplicationRecord
  belongs_to :user
  has_many :break_times, dependent: :destroy
  
  def calculated_time
    duration = end_time ? end_time - start_time : 0

    # 休憩時間を差し引く
    total_break_time = break_times.sum do |break_time|
      break_time.break_end_time ? break_time.break_end_time - break_time.break_start_time : 0
    end
    duration - total_break_time
  end
end
