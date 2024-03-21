class TeamAttendance < ApplicationRecord
  belongs_to :team
  belongs_to :user

  validates :user_id, uniqueness: { scope: :team_id }
  validate :attendance_restriction

  after_create :enqueue_adjust_team_state
  after_destroy :enqueue_adjust_team_state
  
  private

  # 同期間のteamには参加できない
  def attendance_restriction
    return unless user && team

    overlapping_attendance = user.team_attendances.joins(:team).where.not(teams: { id: team.id }).exists?(
      ['? < teams.end_date AND teams.start_date < ?', team.start_date, team.end_date]
    )

    return unless overlapping_attendance

    errors.add('同じ期間中に複数のチームに参加できません')
  end

  def enqueue_adjust_team_state
    AdjustTeamStateJob.perform_later(team.id)
  end
end
