class AddUniqueIndexToTeamAttendances < ActiveRecord::Migration[7.0]
  def change
    add_index :team_attendances, [:user_id, :team_id], unique: true
  end
end
