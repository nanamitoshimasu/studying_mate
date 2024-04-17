class Team < ApplicationRecord
  before_validation :adjust_start_and_end_dates
  before_validation :set_deadline, if: :start_date_changed?
  mount_uploader :thumbnail, TeamThumbnailUploader

  validates :target_time, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :capacity, presence: true
  validates :description, length: { maximum: 655 }
  validate :valid_start_date, if: -> { start_date_changed? && new_record? }
  validate :valid_end_date
  validate :valid_term
  validate :unique_team_in_same_period, on: %i[create update]
  validate :editable_within_start_date, on: :update
  validate :achievable_study_plan, on: %i[create update]

  belongs_to :user
  has_many :team_attendances, dependent: :destroy, class_name: 'TeamAttendance'
  has_many :attendees, through: :team_attendances, class_name: 'User', source: :user
  has_many :timers, dependent: :destroy
  has_one :room, dependent: :destroy
  after_create :create_associated_room
  
  enum status: { wanted: 0, full: 1, finished: 2 }

  # ステータスのメソッド
  def full?
    attendees.count >= capacity
  end

  def deadline?
    Time.current >= deadline
  end

  def update_to_full 
    # statusが:wantedのときのみfullへのステータス変更
    if full? && status == "wanted"
      self.status = :full
      save!
    end
  end

  def update_to_finished
    # デッドラインを過ぎている場合ステータスを更新する
    if deadline? && status == "wanted"
      self.status = :finished
      save
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
  TARGET_TIME_MIN = 10
  TARGET_TIME_MAX = 200
  TARGET_TIME_INCREMENT = 10

  def image_for_time(target_time)
    if target_time.between?(TARGET_TIME_MIN, TARGET_TIME_MAX) && target_time % TARGET_TIME_INCREMENT == 0
      "image_#{target_time}.webp"
    else
      'team_thumbnail_default.webp'
    end
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[title target_time capacity start_date description]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  private

  def valid_start_date
    return unless start_date.present? && start_date <= Time.zone.today

    errors.add(:start_date, 'は明日以降で選択してください。')
  end

  def valid_end_date
    return unless end_date.present? && start_date.present? && end_date < start_date

    errors.add(:end_date, 'は開始日より前の日付を選択できません。')
  end

  def valid_term
    return unless start_date.present? && end_date.present?

    return unless end_date > start_date + 10.days

    errors.add(:end_date, 'は開始日から10日以内で選択してください。。')
  end

  def unique_team_in_same_period
    overlapping_teams = Team.where.not(id: self.id).where(user_id: self.user_id)
                            .where('? < end_date AND start_date < ?', start_date, end_date)
    overlapping_attendance_teams = Team.joins(:team_attendances).where.not(id: self.id).where(team_attendances: {user_id: self.user_id})
                                       .where('? < end_date AND start_date < ?', start_date, end_date)
    if overlapping_teams.exists? || overlapping_attendance_teams.exists?
      errors.add(:base, '指定された期間内に既に他のチームが存在します。')
    end
  end

  def create_associated_room
    create_room # has_one :room の関連付けにより提供されるメソッド
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

  def editable_within_start_date
    if start_date <= Time.current
      errors.add(:base, '編集期限をすぎています。')
    end
  end

  def achievable_study_plan
    return unless target_time && capacity && start_date && end_date

    max_hours_per_day = 12
    required_hours_per_person = target_time.to_f / capacity
    total_required_days = (required_hours_per_person / max_hours_per_day).ceil
    actual_time = ((end_date - start_date).to_i + 1) / 3600 # 設定した期間が秒単位で計算されるので時間に戻す
    actual_days = actual_time / 24

    if actual_days < total_required_days
      errors.add(:base, "絶滅危惧種を救うには#{total_required_days}日必要です！")
    end
  end
end
