class Team < ApplicationRecord
  before_create :set_deadline
  before_validation :adjust_start_and_end_dates
  mount_uploader :thumbnail, TeamThumbnailUploader

  validates :target_time, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :capacity, presence: true
  validates :description, length: { maximum: 655 }
  validate :valid_start_date, if: -> { start_date_changed? && new_record? }
  validate :valid_end_date
  validate :valid_term
  validate :unique_team_in_same_period, on: [:create, :update]

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
      self.save!
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
    (target_time * 3600) - total_calculated_time
  end
 
  # チーム目標時間動物表示
  def image_for_time
    case target_time
      when 10..20
        "image-1.jpg"
      when 30..40
        "image-2.jpg"
      when 50..60
        "image-3.jpg"
      when 70..80
        "image-4.jpg"
      when 90..100
        "image-5.jpg"
      when 110..120
        "image-6.jpg"
      when 130..140
        "image-7.jpg"
      when 150..160
        "image-8.jpg"
      when 170..180
        "image-9.jpg"
      when 190..200
        "image-10.jpg"
      when 210..220
        "image-11.jpg"
      when 230..240
        "image-12.jpg"
      when 250..260
        "image-13.jpg"
      when 270..280
        "image-14.jpg"
      when 290..300
        "image-15.jpg"
      when 310..320
        "image-16.jpg"
      when 330..340
        "image-17.jpg"
      when 350..360
        "image-18.jpg"
      when 370..380
        "image-19.jpg"
      when 390..400
        "image-20.jpg"
      else
        "display_default.png"
    end
  end

  private

  def valid_start_date
    if start_date.present? && start_date <= Date.today
      errors.add(:start_date, "は明日以降で選択してください。")
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
      errors.add(:end_date, "は開始日から10日以内で選択してください。。")
    end
  end

  def unique_team_in_same_period
    overlapping_teams = Team.where.not(id: id).where(user_id: user_id)
                            .where('? < end_date AND start_date < ?', start_date, end_date)
    if overlapping_teams.exists?
      errors.add(:base, '指定された期間内に既に他のチームが存在します。')
    end
  end
  
  # 募集終了時間の設定
  def set_deadline
    self.deadline = start_date - 6.hours
  end

  # startを00:00, endを23:59になるように設定
  def adjust_start_and_end_dates
    self.start_date = start_date.beginning_of_day if start_date.present?

    self.end_date = end_date.end_of_day if end_date.present?
  end
end
