class AddTeamIdToTimers < ActiveRecord::Migration[7.0]
  def change
    add_reference :timers, :team, foreign_key: true
  end
end
