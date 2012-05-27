require 'test_helper'

class ProductAcceptanceTest < ActionDispatch::IntegrationTest
  setup do
    @product = create(:product, name: 'ipad', description: 'awesome ipad from Apple')
  end

  test "show page" do
    visit product_path(@product)
    assert page.has_content?('awesome ipad from Apple')
  end
end
