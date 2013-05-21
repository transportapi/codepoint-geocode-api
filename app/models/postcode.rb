class Postcode < ActiveRecord::Base
   attr_accessible :postcode
   attr_accessible :positional_quality_indicator
   attr_accessible :eastings
   attr_accessible :northings
   attr_accessible :country_code
   attr_accessible :nhs_regional_ha_code
   attr_accessible :nhs_ha_code
   attr_accessible :admin_county_code
   attr_accessible :admin_district_code
   attr_accessible :admin_ward_code
   attr_accessible :postcode_nows
   attr_accessible :osgb
   attr_accessible :latlon


end
