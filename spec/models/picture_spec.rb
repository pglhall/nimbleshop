require 'spec_helper'

describe Picture do
  describe "destroying product should not delete picture" do
    it {
      Picture.count.must_equal 0
      product = create :product
      picture = create :picture, product: product
      product.destroy
      Picture.count.must_equal 2
    }
  end
end
