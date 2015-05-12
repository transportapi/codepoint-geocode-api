ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Add additional requires below this line. Rails is not loaded until this point!
require 'spec_helper'

ActiveRecord::Migration.check_pending!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!
  
  Dir[File.expand_path("../support/**/*.rb", __FILE__)].each do |f| 
    begin
      require f

      file_name = File.basename(f, '.rb')

      if file_name.end_with? 'helper'
        module_name = file_name.camelize.constantize

        config.include(module_name)
      end
    rescue LoadError
      puts "Module from #{f} could not be loaded!"
    end
  end
end
