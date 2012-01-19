require 'spec_helper'

describe ShippingMethod do
  describe "#available_for" do
    let(:shipping_method)  { create(:shipping_method, shipping_price: 100,
                                                      lower_price_limit: 1,
                                                      upper_price_limit: 99)  }
    let(:order)  { create(:order) }
    before do
      order.line_items << create(:line_item)
    end
    it '' do
      shipping_method.available_for(order).must_equal true
    end
  end

  describe "#validations" do
    let(:shipping) { ShippingMethod.new(higher_price_limit: 20) }

    it "allow highter price value nil" do
      shipping.higher_price_limit = nil
      shipping.lower_price_limit  = 45 
      shipping.valid?

      shipping.errors[:lower_price_limit].must_be(:empty?)
    end

    it "wont allow lower price value greater than higher price" do
      shipping.lower_price_limit = 45 
      shipping.valid?

      shipping.errors[:lower_price_limit].wont_be(:empty?)
    end

    it "wont allow lower price value equal to higher price" do
      shipping.lower_price_limit = 20
      shipping.valid?

      shipping.errors[:lower_price_limit].wont_be(:empty?)
    end

    it "allow lower price value greater than higher price" do
      shipping.lower_price_limit = 2
      shipping.valid?

      shipping.errors[:lower_price_limit].must_be(:empty?)
    end

    it "wont allow nil lower price value" do
      shipping.valid?

      shipping.errors[:lower_price_limit].wont_be(:empty?)
    end

    it "wont allow nil name value" do
      shipping.valid?

      shipping.errors[:name].wont_be(:empty?)
    end

    it "wont allow nil shipping price" do
      shipping.valid?

      shipping.errors[:shipping_price].wont_be(:empty?)
    end
  end
end
