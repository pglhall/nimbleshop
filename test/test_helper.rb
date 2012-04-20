require 'bundler'
Bundler.setup(:test)

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'

DatabaseCleaner.strategy = :truncation
Capybara.default_wait_time  = 5

VCR.configure do | c |
  c.ignore_hosts '127.0.0.1', 'localhost'
  c.cassette_library_dir = 'test/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
end

class ActiveSupport::TestCase
  include Factory::Syntax::Methods
  self.use_transactional_fixtures = true
  fixtures :all

  def playcasette(casette)
    VCR.use_cassette(casette)  { yield }
  end
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  self.use_transactional_fixtures = false

  setup { DatabaseCleaner.start }

  teardown do
    DatabaseCleaner.clean
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end

# Require ruby files in support dir.
Dir[File.expand_path('test/support/*.rb')].each { |file| require file }

module RegionalShippingMethodTestHelper
  def create_regional_shipping_method
    create(:country_shipping_method, name: 'Ground', base_price: 3.99, lower_price_limit: 1, upper_price_limit: 99999).regions[0]
  end
end
