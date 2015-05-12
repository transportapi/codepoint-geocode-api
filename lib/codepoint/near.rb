module Codepoint
  module Near

    # REVIEW specify in metres!
    LATLON_DIST_CUTOFF = 0.1
    DEFAULT_N = 1

    module_function

    # Get bounding box from centroid
    def bbox(lat:, lon:)
      # REVIEW be more precise,in metres!
      { minlat: lat - LATLON_DIST_CUTOFF, maxlat: lat + LATLON_DIST_CUTOFF,
        minlon: lon - LATLON_DIST_CUTOFF, maxlon: lon + LATLON_DIST_CUTOFF
      }
    end

    # SQL to get nearest postcodes
    # REVIEW this is fugly! try to achieve the same with where etc
    def get_nearest_postcodes(lat:, lon:, n: DEFAULT_N)
      box = bbox(lat: lat, lon: lon)
      boundbox_sql =
        "ST_GeometryFromText('POLYGON(( #{box[:minlon]} #{box[:minlat]}, " \
        "#{box[:maxlon]} #{box[:minlat]}, #{box[:maxlon]} #{box[:maxlat]}, " \
        "#{box[:minlon]} #{box[:maxlat]}, #{box[:minlon]} #{box[:minlat]}))'" \
        ",4326)"
      distance_sql =
        "ST_DISTANCE(ST_TRANSFORM(ST_GeometryFromText(" \
        "'POINT(#{lon} #{lat})',4326), 27700), osgb)"
      near_sql =
        "SELECT #{distance_sql} as dist, * FROM postcodes WHERE latlon && " \
        "#{boundbox_sql} ORDER BY #{distance_sql} ASC LIMIT #{n}"

      # REVIEW alt approaches to sanitizing, as part of review. This comes from 
      # www.codeitive.com/0NSqVjkUWe/how-to-sanitize-sql-fragment-in-rails.html
      near_sql = ActiveRecord::Base.__send__( :sanitize_sql, [near_sql], '')
      Postcode.find_by_sql(near_sql)
    end
  end
end