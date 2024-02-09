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
  has_many :timers, dependent: :destroy
  
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
    timers.sum(&:calculated_time)
  end

  # チーム学習目標時間残数
  def remaining_time
    (target_time * 3600) - total_calculated_time
  end
 
  # チーム目標時間動物表示
  def image_for_time
    if target_time == 10
      return "image-10.jpg"
    elsif target_time == 20
      return "image-20.jpg"
    elsif target_time == 30
      return "image-30.jpg"
    elsif target_time == 40 
      return "image-40.jpg"
    elsif target_time == 50
      return "image-50.jpg"
    elsif target_time == 60
      return "image-60.jpg"
    elsif target_time == 70
      return "image-70.jpg"
    elsif target_time == 80
      return "image-80.jpg"
    elsif target_time == 90
      return "image-90.jpg"
    elsif target_time == 100
      return "image-100.jpg"
    elsif target_time == 110
      return "image-110.jpg"
    elsif target_time == 120
      return "image-120.jpg"
    elsif target_time == 130
      return "image-130.jpg"
    elsif target_time == 140
      return "image-140.jpg"
    elsif target_time == 150
      return "image-150.jpg"
    elsif target_time == 160
      return "image-160.jpg"
    elsif target_time == 170
      return "image-170.jpg"
    elsif target_time == 180
      return "image-180.jpg"
    elsif target_time == 190
      return "image-190.jpg"
    elsif target_time == 200
      return "image-200.jpg"
    elsif target_time == 210
      return "image-210.jpg"
    elsif target_time == 220
      return "image-220.jpg"
    elsif target_time == 230
      return "image-230.jpg"
    elsif target_time == 240
      return "image-240.jpg"
    elsif target_time == 250
      return "image-250.jpg"
    elsif target_time == 260
      return "image-260.jpg"
    elsif target_time == 270
      return "image-270.jpg"
    elsif target_time == 280
      return "image-280.jpg"
    elsif target_time == 290
      return "image-290.jpg"
    elsif target_time == 300
      return "image-300.jpg"
    elsif target_time == 310
      return "image-310.jpg"
    elsif target_time == 320
      return "image-320.jpg"
    elsif target_time == 330
      return "image-330.jpg"
    elsif target_time == 340
      return "image-340.jpg"
    elsif target_time == 350
      return "image-350.jpg"
    elsif target_time == 360
      return "image-360.jpg"
    elsif target_time == 370
      return "image-370.jpg"
    elsif target_time == 380
      return "image-380.jpg"
    elsif target_time == 390
      return "image-390.jpg"
    elsif target_time == 400
      return "image-400.jpg"
    else
        "display_default.png"
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["title", "target_time", "capacity", "start_date", "description"]
  end
  
  def self.ransackable_associations(auth_object = nil)
     []
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
