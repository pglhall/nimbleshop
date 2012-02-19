=begin
#uncomment this to check coverage 
require 'simplecov'
SimpleCov.start 'rails'
SimpleCov.command_name
=end

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

# Require ruby files in support dir.
Dir[File.expand_path('spec/support/*.rb')].each { |file| require file }

# Do not change to :transaction since :truncation is much faster.
DatabaseCleaner.strategy = :truncation

class MiniTest::Spec
  include Factory::Syntax::Methods

  # Commenting out the code below to make the tests pass. If the following code is uncommented then rake passes. However
  # test using individual acceptance like below fails.
  # bundle exec ruby -Ispec spec/acceptance/products_controller_spec.rb
  #
  #
  #include ActiveSupport::Testing::SetupAndTeardown
  #include ActiveRecord::TestFixtures
  #alias :method_name :__name__ if defined? :__name__
  #self.fixture_path = File.join(Rails.root, 'spec', 'fixtures')
  #fixtures :all

  # Add methods to be used by all specs here...
  before :each do
    DatabaseCleaner.clean

    create(:shop)
    create(:link_group, name: "Shop by category", permalink: 'shop-by-category')
    create(:link_group, name: "Shop by price", permalink: 'shop-by-price')
    PaymentMethod.load_default!
  end
end

def create_authorizenet_payment_method
  unless PaymentMethod.find_by_permalink('authorize-net')
    payment_method = PaymentMethod::AuthorizeNet.create!(name: 'Authorize.net')
    payment_method.authorize_net_login_id = '56yBAar72'
    payment_method.authorize_net_transaction_key = '9r3pbH5bnKH29f7d'
    payment_method.save!
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
