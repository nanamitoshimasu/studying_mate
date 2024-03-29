class User < ApplicationRecord
  mount_uploader :avatar, AvatarUploader

  validates :name, presence: true
  validates :email, presence: true
  validates :description, length: { maximum: 655 }

  has_many :teams, dependent: :destroy
  has_many :team_attendances, dependent: :destroy
  has_many :attend_teams, through: :team_attendances, class_name: 'Team', source: :team
  has_many :timers, dependent: :destroy
  has_many :break_times, dependent: :destroy
  has_many :messages, dependent: :destroy

  def owner?(team)
    team.user_id == id
  end

  def attend(team)
    team_attendances.find_or_create_by(team_id: team.id)
  end

  def attend?(team)
    attend_teams.map(&:id).include?(team.id)
  end

  def cancel_attend(team)
    attend_teams.destroy(team)
  end

  def own?(team)
    team.user_id == id
  end

  def user_total_time
    # ユーザーに紐づいている全てのタイマー
    timers.sum(&:calculated_time)
  end

  def attended_team
    attend_teams.where('start_date <= ? AND end_date >= ?', Time.current, Time.current).order(:end_date).last
  end
  
  class << self
    def find_or_create_from_auth_hash(auth_hash)
      user_params = user_params_from_auth_hash(auth_hash)
      find_or_create_by(email: user_params[:email]) do |user|
        user.update(user_params)
      end
    end

    private

    def user_params_from_auth_hash(auth_hash)
      {
        name: auth_hash.info.name,
        email: auth_hash.info.email,
        avatar: auth_hash.info.avatar
      }
    end
  end
end
