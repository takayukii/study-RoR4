# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160506121212) do

  create_table "bath_day_onsen_pages", force: :cascade do |t|
    t.string   "title",                    limit: 255
    t.text     "url",                      limit: 65535
    t.string   "name",                     limit: 255
    t.string   "category",                 limit: 255
    t.text     "description",              limit: 65535
    t.string   "address",                  limit: 255
    t.string   "tel",                      limit: 255
    t.string   "points",                   limit: 255
    t.string   "price",                    limit: 255
    t.string   "open",                     limit: 255
    t.string   "holiday",                  limit: 255
    t.string   "parking",                  limit: 255
    t.string   "homepage_url",             limit: 255
    t.string   "bath_indoor",              limit: 255
    t.string   "bath_outdoor",             limit: 255
    t.string   "bath_private",             limit: 255
    t.string   "bath_varieties",           limit: 255
    t.string   "bath_remarks",             limit: 255
    t.string   "facilities_rest_public",   limit: 255
    t.string   "facilities_rest_personal", limit: 255
    t.string   "facilities_restaurant",    limit: 255
    t.string   "facilities_massage",       limit: 255
    t.string   "facilities_treatment",     limit: 255
    t.string   "facilities_remarks",       limit: 255
    t.string   "facilities_supply",        limit: 255
    t.string   "facilities_stay",          limit: 255
    t.string   "spa_spot",                 limit: 255
    t.string   "spa_quality",              limit: 255
    t.string   "spa_varieties",            limit: 255
    t.string   "spa_remarks",              limit: 255
    t.string   "neighborhood",             limit: 255
    t.float    "latitude",                 limit: 24
    t.float    "longitude",                limit: 24
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "michinoeki_wikipedia_pages", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "url",         limit: 65535
    t.string   "name",        limit: 255
    t.string   "phrase",      limit: 255
    t.text     "description", limit: 4294967295
    t.string   "zip_code",    limit: 255
    t.string   "address",     limit: 255
    t.float    "latitude",    limit: 24
    t.float    "longitude",   limit: 24
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

end
