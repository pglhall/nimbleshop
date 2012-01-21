require 'spec_helper'

describe "products" do
  include Capybara::DSL

  it "index page" do
    visit root_path
    page.has_content?('Shop by category').must_equal true
  end

  describe "show page" do
    let(:product) { create(:product) }
    it "should be at product show page" do
      visit product_path(product)
      save_and_open_page
    end
  end
end
