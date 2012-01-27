require 'spec_helper'

describe ShippingMethod do

  describe "#available_for" do
    describe "upper_price_limit is present" do
      let(:shipping_method)  { create(:country_shipping_method, lower_price_limit: 10, upper_price_limit: 51) }
      let(:order1)           { create(:order) }
      let(:order2)           { create(:order) }
      it '' do
        order1.line_items << create(:line_item)
        order2.line_items << create(:line_item) << create(:line_item)

        shipping_method.available_for(order1).must_equal true
        shipping_method.available_for(order2).must_equal false
      end
    end
    describe "upper_price_limit is nil" do
      let(:shipping_method)  { create(:country_shipping_method, lower_price_limit: 10, upper_price_limit: nil) }
      let(:order1)           { create(:order) }
      let(:order2)           { create(:order) }
      it '' do
        order1.line_items << create(:line_item)
        order2.line_items << create(:line_item) << create(:line_item)

        shipping_method.available_for(order1).must_equal true
        shipping_method.available_for(order2).must_equal true
      end
    end
  end

  describe "of country type" do
    let(:shipping) { build(:country_shipping_method) }
    subject { shipping }

    it "#validations" do
      shipping.higher_price_limit = 20

      shipping.must have_valid(:name).when("Any name")
      shipping.wont have_valid(:name).when(nil)

      shipping.wont have_valid(:base_price).when(nil)

      shipping.must have_valid(:offset).when(nil)

      shipping.wont have_valid(:lower_price_limit).when(nil)
      shipping.wont have_valid(:lower_price_limit).when(20)
      shipping.wont have_valid(:lower_price_limit).when(40)
      shipping.must have_valid(:lower_price_limit).when(12)
    end

    describe "#shipping_price" do
      it "ignores offset value" do
        shipping.offset = 0.10
        shipping.base_price = 10

        shipping.shipping_price.must_equal 10.0
      end
    end

    describe "on create #callbacks" do
      it "creates all regional shipping zone records" do
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

      shipping.must have_valid(:base_price).when(nil)

      shipping.must have_valid(:offset).when(nil)

      shipping.must have_valid(:lower_price_limit).when(nil)
      shipping.must have_valid(:higher_price_limit).when(nil)
    end

    describe "#shipping_price" do
      it "ignores base_price value" do
        shipping.parent.base_price = 10
        shipping.offset = 0.10
        shipping.base_price = 20

        shipping.shipping_price.to_f.must_equal 10.10
      end
    end

    describe "on create #callbacks" do
      it "does not create all regional shipping zone records" do
        shipping.save
        shipping.regions.count.must_equal 0
      end
    end
  end
end
