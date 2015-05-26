require 'codepoint/representation'
require 'codepoint/near'
 
class PostcodesController < ApplicationController

  before_filter :get_postcode_from_params, :only => [:show]

  before_filter :get_n_from_params, :only => [:near]

  before_filter :get_latlon_from_params, :only => [:near]
  
  # show a postcode
  def show
    # find postcode and respond with the standardised resource representation 
    postcode = Postcode.find_by_postcode_nows(@postcode_str)
    unless postcode.nil?
      resource = Codepoint::Representation.postcode(postcode)
      render :json => resource
    else # if nil
      render :json => {:error => "postcode not found"}
    end
  end

  # find nearest postcode(s) to specified lat/lon
  def near
    # find postcodes and respond with the standardised resource representation     
    postcodes = Codepoint::Near.get_nearest_postcodes(
      lat: @lat, lon: @lon, n: @n
    )
    resource = Codepoint::Representation.postcode_collection(postcodes)
    unless postcodes.nil?
      render :json => resource
    else # if nil
      render :json => {:error => "postcodes not found"}
    end
  end
  
  private

  # get/clean up the postcode query string param
  def get_postcode_from_params
    @postcode_str = params[:postcode]
    @postcode_str.gsub!(/\s+/, "")
    @postcode_str.upcase!
  end
  
  def get_n_from_params
    if params[:n].nil?
      @n = Codepoint::Near::DEFAULT_N
    else
      @n = params[:n].to_i
      @n = Codepoint::Near::DEFAULT_N if @n <=0
    end
  end
  
  def get_latlon_from_params
    @lat = params[:lat].to_f
    @lon = params[:lon].to_f
  end
end
