class Timer < ApplicationRecord
  belongs_to :user
  has_many :break_times, dependent: :destroy
  
  def calculated_time
    duration = end_time - start_time

    # 休憩時間がある場合のみ差し引く
    if break_times.any?
      duration -= break_times.sum { |bt| bt.break_end_time - bt.break_start_time }
    end

    duration
  end
end
