require 'rails_helper'
require 'json'

describe PostcodesController do

  # use factorybot to populate DB
  before :each do
    create(:postcode)
  end

  context '#show' do
    it 'GET #show should retrieve a correctly formatted response' do
      get :show, postcode: 'EX85JF', use_route: 'postcodes/:postcode'
      actual = JSON.parse response.body
      expect_postcode_to_have_required_structure(resp: actual)
    end
  end
end