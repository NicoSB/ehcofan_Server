class AddAttachmentPlayerImageToPlayers < ActiveRecord::Migration
  def self.up
    change_table :players do |t|

      t.attachment :player_image

    end
  end

  def self.down

    remove_attachment :players, :player_image

  end
end
