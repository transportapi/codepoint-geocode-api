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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130520071123) do

  create_table "postcodes", :force => true do |t|
    t.string   "postcode",                     :limit => 8
    t.integer  "positional_quality_indicator"
    t.integer  "eastings"
    t.integer  "northings"
    t.string   "country_code",                 :limit => 9
    t.string   "nhs_regional_ha_code",         :limit => 9
    t.string   "nhs_ha_code",                  :limit => 9
    t.string   "admin_county_code",            :limit => 9
    t.string   "admin_district_code",          :limit => 9
    t.string   "admin_ward_code",              :limit => 9
    t.string   "postcode_nows",                :limit => 7
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.point    "osgb",                         :limit => nil,                 :srid => 27700
    t.point    "latlon",                       :limit => nil,                 :srid => 4326
  end

  add_index "postcodes", ["latlon"], :name => "index_postcodes_on_latlon", :spatial => true
  add_index "postcodes", ["osgb"], :name => "index_postcodes_on_osgb", :spatial => true
  add_index "postcodes", ["postcode_nows"], :name => "index_bus_postcodes_on_postcode_nows", :unique => true

end
