class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.string :url
      t.text :text
      t.datetime :date

      t.timestamps null: false
    end
  end
end
