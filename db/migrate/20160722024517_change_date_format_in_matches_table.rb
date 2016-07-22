class ChangeDateFormatInMatchesTable < ActiveRecord::Migration
  def up
    change_column :matches, :datetime, :datetime
  end

  def down
    change_column :matches, :datetime, :date
  end
end
