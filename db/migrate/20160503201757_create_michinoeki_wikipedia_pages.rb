class CreateMichinoekiWikipediaPages < ActiveRecord::Migration
  def change
    create_table :michinoeki_wikipedia_pages do |t|
      t.string :title
      t.text :url
      t.string :name
      t.string :phrase
      t.string :zip_code
      t.string :address
      t.float :latitude
      t.float :longitude
      t.text :description
      t.timestamps null: false
    end
  end
end
