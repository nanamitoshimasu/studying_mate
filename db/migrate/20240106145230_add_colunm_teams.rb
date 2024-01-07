class AddColunmTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :deadline, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
