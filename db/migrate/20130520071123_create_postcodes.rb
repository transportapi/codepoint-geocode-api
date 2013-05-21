class CreatePostcodes < ActiveRecord::Migration
  def change
    create_table :postcodes do |t|
      t.string   "postcode",             :limit => 8
      t.integer  "positional_quality_indicator"
      t.integer  "eastings"
      t.integer  "northings"
      t.string   "country_code",         :limit => 9
      t.string   "nhs_regional_ha_code", :limit => 9
      t.string   "nhs_ha_code",          :limit => 9
      t.string   "admin_county_code",    :limit => 9
      t.string   "admin_district_code",  :limit => 9
      t.string   "admin_ward_code",      :limit => 9
      t.string   "postcode_nows",        :limit => 7
      t.point    "osgb",                 :limit => nil,                 :srid => 27700
      t.point    "latlon",               :limit => nil,                 :srid => 4326
      t.timestamps
    end
    add_index "postcodes", ["postcode_nows"], :name => "index_bus_postcodes_on_postcode_nows", :unique => true
    add_index "postcodes", ["latlon"], :name => "index_postcodes_on_latlon", :spatial => true
    add_index "postcodes", ["osgb"], :name => "index_postcodes_on_osgb", :spatial => true
  end
end
