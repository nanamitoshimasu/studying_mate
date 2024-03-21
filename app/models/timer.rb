class Timer < ApplicationRecord
  belongs_to :user
  belongs_to :team
  has_many :break_times, dependent: :destroy

  validate :start_time_past
  validate :end_time_past

  def calculated_time
    duration = end_time ? end_time - start_time : 0

    # 休憩時間を差し引く
    total_break_time = break_times.sum do |break_time|
      break_time.break_end_time ? break_time.break_end_time - break_time.break_start_time : 0
    end
    duration - total_break_time
  end

  private

  def start_time_past
    if start_time.present? && start_time > Time.current
      errors.add(:start_time, "は現在時刻より過去である必要があります")
    end
  end

  def end_time_past
    if end_time.present? && start_time.present? && end_time <= start_time
      errors.add(:end_time, "は開始時刻より後である必要があります")
    end

    if end_time.present? && end_time > Time.current
      errors.add(:end_time, "は現在時刻より過去である必要があります")
    end
  end
end
