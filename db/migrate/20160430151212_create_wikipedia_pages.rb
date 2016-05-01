class CreateWikipediaPages < ActiveRecord::Migration
  def change
    create_table :wikipedia_pages do |t|
      t.string :title
      t.text :url
      t.string :name
      t.string :phrase
      t.string :zip_code
      t.string :address
      t.string :latitude
      t.string :longitude
      t.text :description
      t.timestamps null: false
    end
  end
end
