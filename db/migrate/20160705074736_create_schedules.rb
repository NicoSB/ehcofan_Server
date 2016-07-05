class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.boolean :running
      t.integer :interval

      t.timestamps null: false
    end
  end
end
