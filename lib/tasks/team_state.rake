namespace :team_state do
  desc 'Update team status'
  task update_team_state: :environment do
    Team.where(status: :wanted).find_each do |team|
      team.adjust_state
    end
  end
end
