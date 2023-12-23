class Team < ApplicationRecord
  mount_uploader :thumbnail, TeamThumbnailUploader

  validates :target_time, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :capacity, presence: true
  validates :description, length: { maximum: 655 }
  validate :valid_start_date
  validate :valid_end_date

  belongs_to :user

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
end
