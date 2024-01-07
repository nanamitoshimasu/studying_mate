class AddColumnTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :status, :integer, default:0, null: false
  end
end
