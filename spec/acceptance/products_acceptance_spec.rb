require 'spec_helper'

describe "products_acceptance_spec integration" do

  describe "show page" do
    let(:product) { create(:product, name: 'ipad') }
    it {
      click_link 'ipad'
      page.has_content?('This is product description').must_equal true
    }
  end

  describe "all_pictures" do
    let(:product) { create(:product, name: 'blue scarf') }
    let(:picture) { create(:picture, product: product) }
    it {
      visit product_path(picture.product)
      click_link "main-image"
      click_link "product-title"
      page.has_content?('This is product description').must_equal true
    }
  end

end
