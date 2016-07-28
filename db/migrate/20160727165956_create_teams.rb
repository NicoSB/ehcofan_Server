class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.string :competition
      t.integer :wins
      t.integer :ot_wins
      t.integer :ot_losses
      t.integer :losses
      t.integer :goals_for
      t.integer :goals_against

      t.timestamps null: false
    end
  end
end
