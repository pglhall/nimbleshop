# Uncomment below code block and execute `rake` to see test coverage
#
#require 'simplecov'
#SimpleCov.start 'rails'
#SimpleCov.command_name

require 'bundler'

Bundler.setup(:test)

ENV["RAILS_ENV"] = "test"

require File.expand_path('../../config/environment', __FILE__)

require 'minitest/autorun'
require 'minitest/spec'
require "minitest/pride"
require "capybara/rails"
require 'database_cleaner'
require 'rails/test_help'
require "minitest/rails"
require 'minitest-rails-shoulda'
require "mocha"
require "active_support/testing/setup_and_teardown"
require 'vcr'


# Require ruby files in support dir.
Dir[File.expand_path('spec/support/*.rb')].each { |file| require file }

# Do not change to :transaction since :truncation is much faster.
DatabaseCleaner.strategy = :truncation

class MiniTest::Spec
  include FactoryGirl::Syntax::Methods
  include ActiveMerchant::Billing

  before :each do
    DatabaseCleaner.clean
    create(:shop)
    create(:link_group, name: "Shop by category", permalink: 'shop-by-category')
    create(:link_group, name: "Shop by price", permalink: 'shop-by-price')
    PaymentMethod.load_default!
  end
end


def dbify_sql(sql)
  case ActiveRecord::Base.connection.adapter_name
  when "SQLite"
    sql
  when "PostgreSQL"
    sql.gsub('LIKE', 'ILIKE')
  end
end

module RegionalShippingMethodTestHelper
  def create_regional_shipping_method
    create(:country_shipping_method, name: 'Ground', base_price: 3.99, lower_price_limit: 1, upper_price_limit: 99999).regions[0]
  end
end


class IntegerationTest < MiniTest::Spec
  include Capybara::DSL
  include Rails.application.routes.url_helpers
  register_spec_type /(controller|integration)$/i, self
end

class HelperTest < MiniTest::Spec
  include ActiveSupport::Testing::SetupAndTeardown
  include ActionView::TestCase::Behavior
    register_spec_type(/Helper$/, self)
end

VCR.configure do |c|
  c.ignore_hosts '127.0.0.1', 'localhost'
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
end



# TODO
# - write acceptance test for deleting a shipping zone
#
