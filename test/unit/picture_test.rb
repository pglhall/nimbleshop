require 'test_helper'

class PictureTest < ActiveSupport::TestCase
  test "should not save without file" do
    product = create :product

    assert_no_difference 'Picture.count' do
      skip 'skipping for the time being' do
      product.pictures.create
      end
    end
  end

  test "attaching picture to a product" do
    product = create :product
    assert_difference 'product.pictures(true).size' do
      product.attach_picture('cookware.jpg', Rails.root.join('test', 'support', 'images', 'cookware.jpg'))
    end
  end

  test 'deleting product should not delete picture' do
    assert_no_difference 'Picture.count' do
      product = create :product
      product.destroy
    end
  end

end

