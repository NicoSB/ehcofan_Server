class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.string :home_team
      t.string :away_team
      t.string :competition
      t.integer :h1
      t.integer :h2
      t.integer :h3
      t.integer :h_ot
      t.integer :a1
      t.integer :a2
      t.integer :a3
      t.integer :a_ot
      t.date :datetime

      t.timestamps null: false
    end
  end
end
