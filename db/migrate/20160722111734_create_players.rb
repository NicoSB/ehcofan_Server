class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.string :surname
      t.date :birthdate
      t.integer :ep_id
      t.string :nationality
      t.integer :weight
      t.integer :height
      t.string :contract

      t.timestamps null: false
    end
  end
end
