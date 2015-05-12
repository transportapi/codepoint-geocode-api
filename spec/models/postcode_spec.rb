require 'spec_helper' 
require 'rails_helper' 

describe Postcode do  
  
  it "has a valid factory" do 
    expect(create(:postcode)).to be_valid 
  end
end 