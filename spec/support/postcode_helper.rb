module PostcodeHelper

  # REVIEW have a more detailed check: json_equality?
  
  # check the show postcode response structure
  def expect_postcode_to_have_required_structure(resp:) 
    expect(resp['latlon']['x']).to be_truthy
    expect(resp['latlon']['y']).to be_truthy
    expect(resp['postcode']).to be_truthy
  end

  # check the near lat/lon response structure
  def expect_postcode_with_dist_to_have_required_structure(resp:) 
    expect_postcode_to_have_required_structure(resp: resp)
    expect(resp['dist']).to be_truthy
  end
end