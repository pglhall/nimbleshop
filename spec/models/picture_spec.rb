require 'test_helper'

class PictureTest < ActiveSupport::TestCase
  test "attaching picture to a product" do
    product = create :product
    product.pictures.first.destroy
    product.attach_picture('cookware.jpg', Rails.root.join('spec', 'support', 'images', 'cookware.jpg'))
    product = Product.unscoped.last

    assert_equal 1, product.pictures.size

    #when product is destroyed then picture should not be deleted
    assert_equal 1, Picture.count

    product.destroy
    assert_equal 1, Picture.count
  end
end

