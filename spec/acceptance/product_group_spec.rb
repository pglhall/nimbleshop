require 'spec_helper'

describe "product group" do
  include Capybara::DSL

  before do
    Capybara.javascript_driver = :selenium
    Shop.destroy_all
    create(:shop, name: 'Nimble')
  end

  it "should show Nimble shop" do
    visit '/'
    page.has_content?('Nimble').must_equal true
  end
end
