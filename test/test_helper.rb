require 'bundler'
Bundler.setup(:test)

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'

# DatabaseCleaner recommends to use :transaction strategy since it is faster. However using that strategy
# causes a lot of errors like this SQLite3::BusyException: database is locked: commit transaction
# Hence :truncation strategy is used .
DatabaseCleaner.strategy = :truncation
Capybara.default_wait_time  = 5

VCR.configure do | c |
  c.ignore_hosts '127.0.0.1', 'localhost'
  c.cassette_library_dir = 'test/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
end

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  self.use_transactional_fixtures = true
  fixtures :all

  def playcasette(casette)
    VCR.use_cassette(casette)  { yield }
  end
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  self.use_transactional_fixtures = false
  fixtures :all

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
    create(:country_shipping_method, name: 'Ground', base_price: 3.99, minimum_order_amount: 1, maximum_order_amount: 99999).regions[0]
  end
end
