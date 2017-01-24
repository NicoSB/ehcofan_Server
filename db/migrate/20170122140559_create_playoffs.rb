class CreatePlayoffs < ActiveRecord::Migration
  def change
    create_table :playoffs do |t|
      t.string :team1
      t.string :team2
      t.string :title
      t.boolean :running
      t.integer :g1
      t.integer :g2
      t.integer :g3
      t.integer :g4
      t.integer :g5
      t.integer :g6
      t.integer :g7

      t.timestamps null: false
    end
  end
end
