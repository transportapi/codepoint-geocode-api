# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup). Example usage
# rake db:seed path=/home/dmm/mac_dmm/whereconsulting/data/os_open/codepoint/codepoint.csv
# rake db:seed path=/home/dmm/mac_dmm/whereconsulting/data/os_open/codepoint/Data/CSV/al.csv
# rake db:seed path=/home/dmm/mac_dmm/whereconsulting/data/os_open/codepoint/Data/CSV/ze.csv



require 'csv'



# Seed postcodes.
# Create/populate a temp table with same structure as CSV, 
#   then insert into postcodes table from temp table.
# More than 10* faster than the active record, create/save individual postcodes approach.

# 0.5 secs for ze file
# 5.9 secs for al file
# 24 secs for g file
# 1909 secs (32mins) for full file
def seed_postcode_csv_copy(codepoint_file_path, delete) 
      
   # get a connection 
   connection = ActiveRecord::Base.connection();

   # check CSV exists 
   if not File.exist?(codepoint_file_path) 
      puts "Missing seed data file " + codepoint_file_path
      return false
   end
   
   puts "Loading codepoint records from CSV file: " + codepoint_file_path   
   puts "Import process may take several hours "
   
   # delete previous records 
   if delete
      puts 'Deleting records in postcodes table, prior to import'
      connection.execute("delete from postcodes;")
   end
   
   # drop the temp table, if it exists
   drop_temptable_sql =    "DROP TABLE IF EXISTS temp_postcodes"
   connection.execute(drop_temptable_sql)

   # create a temp table to store raw CSV data
   create_temptable_sql =    "CREATE TABLE temp_postcodes (postcode character varying(8), positional_quality_indicator integer, eastings integer, northings integer, country_code character varying(9), nhs_regional_ha_code character varying(9), nhs_ha_code character varying(9), admin_county_code character varying(9), admin_district_code character varying(9), admin_ward_code character varying(9) )"
   connection.execute(create_temptable_sql)

   # copy CSV to temp table
   puts Time.now.to_s+": started copy of CSV to temp table"   
   copy_temptable_sql =    "COPY temp_postcodes FROM '"+codepoint_file_path+"'  DELIMITERS ',' NULL AS '' CSV"
   connection.execute(copy_temptable_sql)

   # insert from temp table ()
   puts Time.now.to_s+": started insert into postcodes from temp table"   
   insert_postcodes_table_sql = "INSERT INTO postcodes (postcode,  positional_quality_indicator,  eastings,  northings,  country_code,  nhs_regional_ha_code,  nhs_ha_code,  admin_county_code,  admin_district_code,  admin_ward_code, postcode_nows, created_at, updated_at)
      SELECT postcode,  positional_quality_indicator,  eastings,  northings,  country_code,  nhs_regional_ha_code,  nhs_ha_code,  admin_county_code,  admin_district_code,  admin_ward_code, regexp_replace(postcode, '[ \t\n\r]*', '', 'g'), current_timestamp, current_timestamp FROM temp_postcodes"
   connection.execute(insert_postcodes_table_sql)
   
   # create geom, from SQL
   puts Time.now.to_s+": started update of osgb geom"  
   connection.execute("UPDATE postcodes SET osgb = geometryfromtext('POINT('||eastings||' '||northings||')',27700)")
   puts Time.now.to_s+": started update of latlon geom"   
   connection.execute("UPDATE postcodes SET latlon = ST_TRANSFORM(osgb, 4326)")

   # count - for diagnostics
   count_pcs_sql = "select count(*) from postcodes"
   count_pcs = connection.execute(count_pcs_sql)
   i = count_pcs[0]['count']

   # close connection
   connection.close()
   
   puts 'Seeded DB with '+i.to_s+' postcodes'
end

# Seed postcodes by creating individual Postcodes using active record
# This way is slow! 5 hr insert for full, 6secs for ze file, 98 secs for al file
#
def seed_postcode_activerecord(codepoint_file_path, delete) 
      
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
   connection.close()

   puts 'Seeded DB with '+i.to_s+' postcodes'
end


start_time = Time.now
puts start_time.to_s+": Started seeding postcodes process"

# Get file (TODO check it exists)
codepoint_file_path = ENV['path'].to_s
if codepoint_file_path=='' || codepoint_file_path.nil?
   puts "No codepoint path specified. Append rake command with ' path=/path/to/codepoint.csv'"
   abort
end

delete = true
#seed_postcode_activerecord(codepoint_file_path, delete) 
seed_postcode_csv_copy(codepoint_file_path, delete) 

end_time = Time.now
duration = end_time - start_time
puts end_time.to_s+": finished seeding postcodes"
puts "Process took "+duration.to_s+" secs"
