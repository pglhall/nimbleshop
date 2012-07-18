require 'bundler'
Bundler.setup(:test)

ENV["RAILS_ENV"] = "test"
require File.expand_path("../../../../nimbleshop_core/test/myshop/config/environment.rb",  __FILE__)
require 'rails/test_help'
require 'capybara/rails'

# DatabaseCleaner recommends to use :transaction strategy since it is faster. However using that strategy
# causes a lot of errors like this SQLite3::BusyException: database is locked: commit transaction
# Hence :truncation strategy is used .
require 'factory_girl'
Dir["#{File.dirname(__FILE__)}/../../../nimbleshop_core/test/factories/**"].each { |f| require File.expand_path(f) }

require 'active_record/fixtures'

DatabaseCleaner.strategy = :truncation
Capybara.default_wait_time  = 5

VCR.configure do | c |
  c.ignore_hosts '127.0.0.1', 'localhost'
  c.cassette_library_dir = 'test/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
end

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  self.use_transactional_fixtures = false
  setup do
    DatabaseCleaner.start
    ActiveRecord::Fixtures.create_fixtures("#{File.dirname(__FILE__)}/../../../nimbleshop_core/test/fixtures", ['shops', 'link_groups', 'payment_methods'])
  end
  teardown do
    DatabaseCleaner.clean
  end

  def playcasette(casette)
    VCR.use_cassette(casette)  { yield }
  end
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  self.use_transactional_fixtures = false
  setup do
    DatabaseCleaner.start
    ActiveRecord::Fixtures.create_fixtures("#{File.dirname(__FILE__)}/../../nimbleshop_core/test/fixtures", ['shops', 'link_groups', 'payment_methods'])
  end

  teardown do
    DatabaseCleaner.clean
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end

Dir["#{File.dirname(__FILE__)}/../../../nimbleshop_core/test/support/**"].each do |f|
  require File.expand_path(f) unless File.directory? f
end
