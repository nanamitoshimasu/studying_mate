class AdjustTeamStateJob < ApplicationJob
  queue_as :default

  def perform(team_id)
    team = Team.find(team_id)
    team.update_to_full if team.full?
  end
end
