class CreateBathDayOnsenPages < ActiveRecord::Migration
  def change
    create_table :bath_day_onsen_pages do |t|
      t.string :title
      t.text :url
      t.string :name
      t.string :category
      t.text :description
      t.string :address
      t.string :tel
      t.string :points
      t.string :price
      t.string :open
      t.string :holiday
      t.string :parking
      t.string :homepage_url
      t.string :bath_indoor
      t.string :bath_outdoor
      t.string :bath_private
      t.string :bath_varieties
      t.string :bath_remarks
      t.string :facilities_rest_public
      t.string :facilities_rest_personal
      t.string :facilities_restaurant
      t.string :facilities_massage
      t.string :facilities_treatment
      t.string :facilities_remarks
      t.string :facilities_supply
      t.string :facilities_stay
      t.string :spa_spot
      t.string :spa_quality
      t.string :spa_varieties
      t.string :spa_remarks
      t.string :neighborhood
      t.float :latitude
      t.float :longitude
      t.timestamps null: false
    end
  end
end
