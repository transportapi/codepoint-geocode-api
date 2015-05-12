FactoryGirl.define do 
  factory :postcode do |p| 
    p.postcode 'EX8 5JF'
    p.positional_quality_indicator 10
    p.eastings 299123
    p.northings 83983
    p.country_code 'E92000001'
    p.nhs_regional_ha_code 'E19000002'
    p.nhs_ha_code 'E18000010'
    p.admin_county_code 'E10000008'
    p.admin_district_code 'E07000040'
    p.admin_ward_code 'E05003489'
    p.postcode_nows 'EX85JF'
    p.osgb '0101000020346C000000000000CC41124100000000F080F440'
    p.latlon '0101000020E610000066FA89FDDE6C0BC01B87BD5FC9524940'
  end 
end
