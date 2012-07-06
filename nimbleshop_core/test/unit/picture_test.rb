require 'test_helper'

class PictureTest < ActiveSupport::TestCase

  test 'validity of factory' do
    create :picture
    assert_equal 1, Picture.count
  end

  test "attaching picture to a product" do
    product = create :product
    assert_difference 'product.pictures(true).size' do
      file = File.expand_path('../../fixtures/files/avatar.png', __FILE__)
      product.attach_picture('avatar.png', file)
    end
  end

  test 'deleting product should not delete picture' do
    product = create :product
    assert_no_difference 'Picture.count' do
      product.destroy
    end
  end
end
