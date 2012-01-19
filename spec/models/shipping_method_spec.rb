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

  describe "#callbacks" do
    let(:shipping_zone) do
      CountryShippingZone.create_by_carmen_code("US")
    end

    before do
      @shipping_method = ShippingMethod.new(lower_price_limit: 34)
      @shipping_method.name = 'ground shipping'
      @shipping_method.higher_price_limit = 44.5
      @shipping_method.shipping_price = 24.5
      @shipping_method.shipping_zone = shipping_zone
    end

    it "will create all regional shipping zones shipping methods" do
      shipping_methods = ShippingMethod.count
      @shipping_method.save
      count = shipping_zone.regional_shipping_zones.count + 1

      (ShippingMethod.count - shipping_methods).must_equal count
    end

    it "newly created regional shipping methods should inherit attributes from country" do
      @shipping_method.save
      alabama = RegionalShippingZone.find_by_code("AL")
      alabama_shipping_method = ShippingMethod.find_by_shipping_zone_id(alabama.id)

      alabama_shipping_method.lower_price_limit.must_equal 34
      alabama_shipping_method.higher_price_limit.must_equal 44.5
      alabama_shipping_method.shipping_price.must_equal 24.5
    end
  end
end
