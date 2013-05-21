# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

require 'csv'


# Seed postcodes TODO mass CSV insert?
# 5 hr insert :-(
def seed_postcode(codepoint_file_path, delete) 
      
   if not File.exist?(codepoint_file_path) 
      puts "Missing seed data file " + codepoint_file_path
      return false
   end
   
   puts "Loading codepoint records from CSV file: " + codepoint_file_path   
   
   if delete
     puts 'first delete everything in codepoint table'
     Postcode.delete_all
   end
   i = 0
   check_interval = 100
   CSV.foreach(codepoint_file_path) do |row|   
      postcode = row[0]
      postcode_nows = postcode.gsub(/\s+/, "")
      
      # TODO eastings get screwed up!
      eastings =  row[2]
      northings = row[3]
   
      osgb = Point.from_x_y(eastings, northings)
      pc = Postcode.create(
              :postcode =>     row[0],
              :positional_quality_indicator =>          row[1],
              :eastings =>     eastings,
              :northings =>  northings,
              :country_code =>      row[4],
              :nhs_regional_ha_code =>     row[5],
              :nhs_ha_code =>     row[6],
              :admin_county_code =>         row[7],
              :admin_ward_code =>         row[8],
              :admin_county_code =>         row[9],
              :postcode_nows =>         postcode_nows)
      i =i+1
      if i % check_interval == 0
        puts 'inserted '+i.to_s+' postcodes...'
      end
   end
   
   # create geom, from SQL
   connection = ActiveRecord::Base.connection();
   connection.execute("UPDATE postcodes SET osgb = geometryfromtext('POINT('||eastings||' '||northings||')',27700)")
   connection.execute("UPDATE postcodes SET latlon = ST_TRANSFORM(osgb, 4326)")
   
   puts 'Seeded DB with '+i.to_s+' postcodes'
end


#codepoint_file_path = '/home/dmm/mac_dmm/whereconsulting/data/os_open/codepoint/codepoint.csv'
codepoint_file_path = '/home/dmm/mac_dmm/whereconsulting/data/os_open/codepoint/Data/CSV/ze.csv'
delete = true
seed_postcode(codepoint_file_path, delete) 

