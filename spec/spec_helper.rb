require "minitest/autorun"
require "minitest/pride"
require "minitest/rails"

require 'database_cleaner'

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'capybara/rails'

# Do not change to :transaction since :truncation is much faster.
DatabaseCleaner.strategy = :truncation

class MiniTest::Spec
  include Factory::Syntax::Methods

  # Add methods to be used by all specs here...
  before :each do
    DatabaseCleaner.clean

    create(:shop)
    create(:link_group, permalink: 'shop-by-category')
    create(:link_group, permalink: 'shop-by-price')
    PaymentMethod.load_default!
  end

  include Rails.application.routes.url_helpers
  include Capybara::DSL
end

# Uncomment to support fixtures in Model tests...
# require "active_record/fixtures"
class MiniTest::Rails::Model
  # include ActiveRecord::TestFixtures
  # self.fixture_path = File.join(Rails.root, "test", "fixtures")
end

class Object
  def must_be_like other
    gsub(/\s+/, ' ').strip.must_equal other.gsub(/\s+/, ' ').strip
  end
end

def create_authorizenet_payment_method
  unless PaymentMethod.find_by_permalink('authorize-net')
    payment_method = PaymentMethod::AuthorizeNet.create!(name: 'Authorize.net')
    payment_method.write_preference(:login_id, '56yBAar72')
    payment_method.write_preference(:transaction_key, '9r3pbH5bnKH29f7d')
    payment_method.save!
  end
end

# These classes needed to be loaded so that they the preference method
#PaymentMethod::Splitable
#PaymentMethod::PaypalWebsitePaymentsStandard
#PaymentMethod::AuthorizeNet
