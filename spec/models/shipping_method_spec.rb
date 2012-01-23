require 'spec_helper'

describe ShippingMethod do
  describe "#available_for" do
    let(:shipping_method)  { create(:country_shipping_method) }
    let(:order)            { create(:order) }
    before do
      order.line_items << create(:line_item)
    end
    it '' do
      shipping_method.available_for(order).must_equal true
    end
  end

  describe "of country type" do
    let(:shipping) { build(:country_shipping_method) }

    describe "#validations" do

      it "allow highter price value nil" do
        shipping.higher_price_limit = nil
        shipping.lower_price_limit  = 45 
        shipping.valid?

        shipping.errors[:lower_price_limit].must_be(:empty?)
      end

      it "will allow offset to be nil" do
        shipping.offset = nil
        shipping.valid?

        shipping.errors[:offset].must_be(:empty?)
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
        shipping.lower_price_limit = nil
        shipping.valid?

        shipping.errors[:lower_price_limit].wont_be(:empty?)
      end

      it "wont allow nil name value" do
        shipping.name = nil
        shipping.valid?

        shipping.errors[:name].wont_be(:empty?)
      end

      it "wont allow nil shipping price" do
        shipping.shipping_price = nil

        shipping.valid?

        shipping.errors[:shipping_price].wont_be(:empty?)
      end
    end

    describe "on create #callbacks" do
      it "will create all regional shipping zones shipping methods" do
        shipping.save
        shipping.regions.count.must_equal 57
      end
    end
  end

  describe "of state type" do
    let(:shipping) { build(:regional_shipping_method) }

    describe "#validations" do

      it "allow highter price value nil" do
        shipping.higher_price_limit = nil
        shipping.valid?

        shipping.errors[:higher_price_limit].must_be(:empty?)
      end

      it "will allow offset to be nil" do
        shipping.offset = nil
        shipping.valid?

        shipping.errors[:offset].must_be(:empty?)
      end

      it "allow lower price value greater than higher price" do
        shipping.lower_price_limit = nil
        shipping.valid?

        shipping.errors[:lower_price_limit].must_be(:empty?)
      end

      it "wont allow nil name value" do
        shipping.name = nil
        shipping.valid?

        shipping.errors[:name].wont_be(:empty?)
      end

      it "allow nil shipping price" do
        shipping.shipping_price = nil

        shipping.valid?

        shipping.errors[:shipping_price].must_be(:empty?)
      end
    end

    describe "on create #callbacks" do
      it "wont create all regional shipping zones shipping methods" do
        shipping.save
        shipping.regions.count.must_equal 0
      end
    end
  end
end
