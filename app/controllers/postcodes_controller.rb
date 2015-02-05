class PostcodesController < ApplicationController

   # show a postcode
   def show
      # get the postcode HTTP param (TODO if params[:postcode].nil?, json error)
      postcode_str = params[:postcode]
      # strip whitespace / upcase
      postcode_str.gsub!(/\s+/, "")
      postcode_str.upcase!

      # find matching
      postcode = Postcode.find_by_postcode_nows(postcode_str)
      
      # respond
      unless postcode.nil?
        render :json => postcode
      else # if nil
         render :json => {:error => "postcode not found"}
      end
   end

   # find nearest postcode(s)
   def near

      # get lat/lon. Nils and weirdness defaults to 0.0
      lat = params[:lat].to_f
      lon = params[:lon].to_f

      # get n. Defaults to 1. TODO limit?
      n=params[:n].to_i unless params[:n].nil?
      if (n==0 || n.nil?); n=1 end
      puts "n = "+n.to_s

      puts 'find nearest n'
      # the cutoff 'distance' in latlon: a heuristic to speed up processing
		# TODO in native 27700 srs
      latlon_dist_cutoff = 0.1
      minlat = lat - latlon_dist_cutoff
      maxlat = lat + latlon_dist_cutoff
      minlon = lon - latlon_dist_cutoff
      maxlon = lon + latlon_dist_cutoff

      # set the bounds in lat/lon
      # TODO as a scope?
      boundbox_sql = "ST_GeometryFromText('POLYGON(( "+minlon.to_s+" "+minlat.to_s+", "+maxlon.to_s+" "+minlat.to_s+", 
      "+maxlon.to_s+" "+maxlat.to_s+", "+minlon.to_s+" "+maxlat.to_s+", "+minlon.to_s+" "+minlat.to_s+"))',4326)"
      # TODO as a scope?
      # order by distance in projected 27700 SRS (metres).
      distance_sql = "ST_DISTANCE(ST_TRANSFORM(ST_GeometryFromText('POINT("+lon.to_s+" "+lat.to_s+")',4326), 27700), osgb)"
      nearest_sql = "SELECT "+distance_sql+" as dist, * FROM postcodes
      WHERE latlon && "+boundbox_sql+" ORDER BY "+distance_sql+" ASC LIMIT "+n.to_s
      puts nearest_sql

      postcodes = Postcode.find_by_sql(nearest_sql)

      # respond TODO add distance from specified point
      unless postcodes.nil?
         render :json => postcodes
      else # if nil
         render :json => {:error => "postcodes not found"}
      end

   end
end
