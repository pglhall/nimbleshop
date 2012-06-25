require 'test_helper'

class PictureTest < ActiveSupport::TestCase

  test 'validity of factory' do
    create :picture
    assert_equal 1, Picture.count
  end

  test "attaching picture to a product" do
    product = create :product
    assert_difference 'product.pictures(true).size' do
      product.attach_picture('cookware.jpg', Rails.root.join('test', 'support', 'images', 'cookware.jpg'))
    end
  end

  test 'deleting product should not delete picture' do
    product = create :product
    assert_no_difference 'Picture.count' do
      product.destroy
    end
  end
end
