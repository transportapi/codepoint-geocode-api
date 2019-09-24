require 'rails_helper'
require 'json'

describe PostcodesController do

  # use factorybot to populate DB
  before :each do
    create(:postcode)
  end

  context '#near' do
    it 'GET #near should retrieve a correctly formatted response' do
      get :near, lon: '-3.42815', lat: '50.64677', n: 1, use_route: 'postcodes'
      actual = JSON.parse(response.body)[0]
      expect_postcode_with_dist_to_have_required_structure(resp: actual)
    end
  end
end