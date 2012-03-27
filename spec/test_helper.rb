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
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
end

class ActiveSupport::TestCase
  include Factory::Syntax::Methods
  self.fixture_path = "#{::Rails.root}/spec/fixtures"
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures = false
  fixtures :all
end


class ActionDispatch::IntegrationTest
  include Capybara::DSL
  self.use_transactional_fixtures = false
  self.fixture_path = "#{::Rails.root}/spec/fixtures"

  setup { DatabaseCleaner.start }

  teardown do
    DatabaseCleaner.clean
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
