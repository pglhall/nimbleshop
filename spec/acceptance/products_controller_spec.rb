require 'spec_helper'

describe "products" do
  include Capybara::DSL

  it "should be at home page" do
    visit root_path
    page.has_content?('Shop by category').must_equal true
  end

  describe "product show page" do
    let(:product) { create(:product) }
    it "should be at product show page" do
      skip do
        visit product_path(product)
        save_and_open_page
      end
    end
  end
end
