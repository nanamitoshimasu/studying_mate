class Team < ApplicationRecord
  before_validation :adjust_start_and_end_dates
  before_create :set_deadline
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
    # デッドラインを過ぎているか、もしくは定員に達している場合のみステータスを更新する
    return unless deadline? || full?

    new_status = deadline? ? :finished : :full

    self.status = new_status
    save!
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
      'image_10.jpg'
    elsif target_time == 20
      'image_20.jpg'
    elsif target_time == 30
      'image_30.jpg'
    elsif target_time == 40
      'image_40.jpg'
    elsif target_time == 50
      'image_50.jpg'
    elsif target_time == 60
      'image_60.jpg'
    elsif target_time == 70
      'image_70.jpg'
    elsif target_time == 80
      'image_80.jpg'
    elsif target_time == 90
      'image_90.jpg'
    elsif target_time == 100
      'image_100.jpg'
    elsif target_time == 110
      'image_110.jpg'
    elsif target_time == 120
      'image_120.jpg'
    elsif target_time == 130
      'image_130.jpg'
    elsif target_time == 140
      'image_140.jpg'
    elsif target_time == 150
      'image_150.jpg'
    elsif target_time == 160
      'image_160.jpg'
    elsif target_time == 170
      'image_170.jpg'
    elsif target_time == 180
      'image_180.jpg'
    elsif target_time == 190
      'image_190.jpg'
    elsif target_time == 200
      'image_200.jpg'
    else
      'team_thumbnail_default.jpg'
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
    overlapping_teams = Team.where.not(id:).where(user_id:)
                            .where('? < end_date AND start_date < ?', start_date, end_date)
    return unless overlapping_teams.exists?

    errors.add(:base, '指定された期間内に既に他のチームが存在します。')
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
