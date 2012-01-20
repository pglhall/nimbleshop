require 'spec_helper'

describe "products" do
  include Capybara::DSL

  it "should be at home page" do
    visit root_path
    save_and_open_page
    page.has_content?('Shop by category').must_equal true
  end
end
