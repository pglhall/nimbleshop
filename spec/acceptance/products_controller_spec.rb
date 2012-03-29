require 'spec_helper'

describe "products_acceptance_spec integration" do

  it "index page" do
    visit root_path
    page.must_have_content('Shop by category')
  end

  it "index page when default link group deleted" do
    LinkGroup.find_by_permalink('shop-by-price').destroy
    visit root_path
    page.must_have_content('Shop by category')
  end

  describe "show page" do
    let(:product) { create(:product) }
    it "should be at product show page" do
      visit product_path(product)
      #save_and_open_page
      page.has_content?('This is product description').must_equal true
    end
  end

  describe "all_pictures" do
    let(:product) { create(:product, name: 'blue scarf') }
    let(:picture) { create(:picture, product: product) }
    it "should have right values" do
      visit product_path(picture.product)
      click_link "main-image"
      click_link "product-title"
      page.has_content?('This is product description').must_equal true
      #save_and_open_page
    end
  end

end
