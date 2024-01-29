class Team < ApplicationRecord
  before_create :set_deadline
  mount_uploader :thumbnail, TeamThumbnailUploader

  validates :target_time, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :capacity, presence: true
  validates :description, length: { maximum: 655 }
  validate :valid_start_date
  validate :valid_end_date
  validate :valid_term

  belongs_to :user
  has_many :team_attendances, dependent: :destroy, class_name: 'TeamAttendance'
  has_many :attendees, through: :team_attendances, class_name: 'User', source: :user

  enum status: { wanted: 0, full: 1, finished: 2 }
  
  # ステータスのメソッド
  def full?
    attendees.count >= capacity
  end

  def deadline?
    Time.current >= deadline
  end

  def adjust_state
    Rails.logger.debug "Current status: #{self.status}"
    Rails.logger.debug "Is deadline reached?: #{deadline?}"
    
    # デッドラインを過ぎているか、もしくは定員に達している場合のみステータスを更新する
    if deadline? || full?
      new_status = deadline? ? :finished : :full
      Rails.logger.debug "New status: #{new_status}"
      
      self.status = new_status
      self.save
    end
  end
    
  scope :wanted_finished, -> { where('deadline <= ?', Time.current) }

  # チームの合計学習時間数のメソッド
  def total_calculated_time
    attendees.includes(:timers).inject(0) do |sum, attendee|
      attendee_timers_sum = attendee.timers.inject(0) { |attendee_sum, timer| attendee_sum + timer.calculated_time }
      sum + attendee_timers_sum
    end
  end

  # チーム学習目標時間残数
  def remaining_time
    target_time - total_calculated_time
  end
  
  private

  def valid_start_date
    if start_date.present? && start_date < Date.today
      errors.add(:start_date, "は過去の日付を選択できません。")
    end
  end

  def valid_end_date
    if end_date.present? && start_date.present? && end_date < start_date
      errors.add(:end_date, "は開始日より前の日付を選択できません。")
    end
  end

  def valid_term
    return unless start_date.present? && end_date.present?

    if end_date > start_date + 10.days
      errors.add(:end_date, "は開始日から10日以内で設定してください。")
    end
  end

  def set_deadline
    self.deadline = start_date - 12.hours
  end
end
