require 'database_cleaner'
require 'rubygems'
require 'factory_girl_rails'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|

  config.include FactoryGirl::Syntax::Methods

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # Setup db cleaning
  config.before(:suite) do
    DatabaseCleaner.strategy = :deletion, {:except => %w[spatial_ref_sys]}
    DatabaseCleaner.clean_with :truncation, {:except => %w[spatial_ref_sys]}
  end

  config.before(:each) do
    DatabaseCleaner.clean
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
