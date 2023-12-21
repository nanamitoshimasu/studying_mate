class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams do |t|
      
      t.integer :target_time, null: false
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.integer :capacity, null: false
      t.string :thubmnail 
      t.text :description
      t.string :title
      t.references :user, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
