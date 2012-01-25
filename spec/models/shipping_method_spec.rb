require 'spec_helper'

describe ShippingMethod do

  describe "#available_for" do
    let(:shipping_method)  { create(:country_shipping_method) }
    let(:order)            { create(:order) }
    before do
      order.line_items << create(:line_item)
    end
    it '' do
      #shipping_method.available_for(order).must_equal true
    end
  end

  describe "of country type" do
    let(:shipping) { build(:country_shipping_method) }
    subject { shipping }

    it "#validations" do
      shipping.higher_price_limit = 20

      shipping.must have_valid(:name).when("Any name")
      shipping.wont have_valid(:name).when(nil)

      #shipping.wont have_valid(:lower_price_limit).when(-20)

      shipping.wont have_valid(:base_price).when(nil)

      shipping.must have_valid(:offset).when(nil)

      shipping.wont have_valid(:lower_price_limit).when(nil)
      shipping.wont have_valid(:lower_price_limit).when(20)
      shipping.wont have_valid(:lower_price_limit).when(40)
      shipping.must have_valid(:lower_price_limit).when(12)
    end

    describe "#shipping_price" do
      it "will ignore offset value" do
        shipping.offset = 0.10
        shipping.base_price = 10

        shipping.shipping_price.must_equal 10.0
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

    it "#validations" do
      shipping.must have_valid(:name).when("Any name")
      shipping.wont have_valid(:name).when(nil)

      #shipping.wont have_valid(:lower_price_limit).when(-20)

      shipping.must have_valid(:base_price).when(nil)

      shipping.must have_valid(:offset).when(nil)

      shipping.must have_valid(:lower_price_limit).when(nil)
      shipping.must have_valid(:higher_price_limit).when(nil)
    end

    describe "#shipping_price" do
      it "will ignore base_price value" do
        shipping.parent.base_price = 10
        shipping.offset = 0.10
        shipping.base_price = 20

        shipping.shipping_price.to_f.must_equal 10.10
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
