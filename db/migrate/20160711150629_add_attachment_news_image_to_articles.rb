class AddAttachmentNewsImageToArticles < ActiveRecord::Migration
  def self.up
    change_table :articles do |t|

      t.attachment :news_image

    end
  end

  def self.down

    remove_attachment :articles, :news_image

  end
end
