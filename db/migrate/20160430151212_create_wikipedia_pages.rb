class CreateWikipediaPages < ActiveRecord::Migration
  def change
    create_table :wikipedia_pages do |t|
      t.string :title
      t.text :url
      t.text :body
      t.string :station_name
      t.string :address
      t.timestamps null: false
    end
  end
end
