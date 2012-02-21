require 'spec_helper'

describe ShippingMethod do
  include RegionalShippingMethodTestHelper


  describe "regional" do
    describe "#validations" do
      subject { create_regional_shipping_method }

      it  {
        must validate_presence_of(:name)
        wont validate_presence_of(:base_price)
        #must validate_presence_of(:offset)
        wont validate_presence_of(:lower_price_limit)
        wont validate_presence_of(:higher_price_limit)
      }
    end
  end

  describe "country" do
    describe "#validations" do
      subject { create(:country_shipping_method, higher_price_limit: 20) }
      it  {
        must validate_presence_of(:name)
        must validate_presence_of(:base_price)
        wont validate_presence_of(:offset)
        must validate_presence_of(:lower_price_limit)
        must allow_value(19).for(:lower_price_limit)
        wont allow_value(20).for(:lower_price_limit)
        wont allow_value(21).for(:lower_price_limit)
      }
    end
  end


  describe "#scopes" do
    def with_regions(countries)
      countries + countries.map(&:regions).flatten
    end
    before do
      @us = create(:country_shipping_zone, country_code: 'US')
      @ca = create(:country_shipping_zone, country_code: 'CA')
      @hk = create(:country_shipping_zone, country_code: 'HK')

      @usground1  = create(:shipping_method, lower_price_limit: 0, higher_price_limit: nil, base_price: 3.99, shipping_zone: @us)
      @usair1     = create(:shipping_method, lower_price_limit: 0, higher_price_limit: 600, base_price: 8.99, shipping_zone: @us)
      @hkground1  = create(:shipping_method, lower_price_limit: 100, higher_price_limit: 1000, base_price: 8.99, shipping_zone: @hk)
      @caground1  = create(:shipping_method, lower_price_limit: 0, higher_price_limit: 700, base_price: 5.99, shipping_zone: @ca)
      @hkair1     = create(:shipping_method, lower_price_limit: 900, higher_price_limit: 2000, base_price: 28.99, shipping_zone: @hk)
    end

    describe "#in_price_range" do
      it "knows in which shipping methods are available" do
        result = ShippingMethod.in_price_range(1500).to_ary
        result.must_have_same_elements with_regions([@hkair1, @usground1])
      end
    end

    describe "#atmost" do
      it "knows who price is less than the given amount" do
        ShippingMethod.atmost(1000).to_ary.must_have_same_elements  with_regions([ @usground1, @hkground1, @hkair1])
        ShippingMethod.atmost(0).to_ary.must_have_same_elements with_regions([ @usground1, @usair1, @hkground1, @caground1, @hkair1])
      end
    end

    describe "#aleast" do
      it "knows who price is greater than the given amount" do
        ShippingMethod.atleast(10).to_ary.must_have_same_elements  with_regions([ @usground1, @usair1, @caground1])
      end
    end

    describe "#in_country" do
      it "knows by country code" do
        ShippingMethod.in_country('US').to_ary.must_have_same_elements with_regions([@usground1, @usair1])
      end
    end

    describe "#available_countries" do
      it "knows countries where shipping method available for the price" do
        ShippingMethod.available_for_countries(1000).must_have_same_elements ['US', 'HK']
      end
    end
  end

  describe "making country level shipping method inactive should make children inactive" do
    describe "updating record" do
      it {
        shipping_method = create(:country_shipping_method)
        region = shipping_method.regions.first
        region.active.must_equal true
        shipping_method.update_attributes!(active: false)
        region.reload
        region.active.must_equal false
      }
    end
    describe "creating record" do
      it {
        shipping_method = create(:country_shipping_method, active: false)
        region = shipping_method.regions.first
        region.active.must_equal false
      }
    end
  end

  describe "#enable! #disable!" do
    it {
      shipping = create(:country_shipping_method)

      shipping.enable!
      shipping.must_be(:active)

      shipping.disable!
      shipping.wont_be(:active)
    }
  end

  describe "#update_offset" do
    let(:shipment) { ShippingMethod.new(base_price: 10) }
    describe "of country" do
      it "is not going to update" do
        shipment.shipping_zone = CountryShippingZone.new

        shipment.update_offset(0.20)

        shipment.offset.to_f.must_equal 0.0
      end
    end

    describe "of state" do
      it "is going to increase by 0.20" do
        shipment.shipping_zone = RegionalShippingZone.new

        shipment.update_offset(0.20)

        shipment.offset.to_f.must_equal 0.20
      end

      it "is going to decreate by 0.20" do
        shipment.shipping_zone = RegionalShippingZone.new
        shipment.offset = 0.80

        shipment.update_offset(-0.20)

        shipment.offset.to_f.must_be_within_delta 0.60
      end
    end
  end

  describe "#available_for" do
    describe "with one shipping method" do
      it {
        shipping_method = create(:country_shipping_method, lower_price_limit: 10, upper_price_limit: 51)
        CountryShippingZone.count.must_equal 1
        RegionalShippingZone.count.must_equal 57
        shipping_method.shipping_zone.country_code.must_equal 'US'

        address = create(:shipping_address, state_code: 'FL', country_code: 'US')
        address.state_code.must_equal 'FL'
        RegionalShippingZone.count(conditions: {state_code: 'FL', country_code: 'US'}).must_equal 1

        ShippingMethod.available_for(25, address).size.must_equal 1
        ShippingMethod.available_for(200, address).size.must_equal 0
      }
    end

    describe "with two shipping methods" do
      it {
        create(:country_shipping_method, lower_price_limit: 10, upper_price_limit: 51, name: 'General')
        create(:country_shipping_method, lower_price_limit: 10, upper_price_limit: 51, name: 'Express')
        RegionalShippingZone.count(conditions: {state_code: 'FL', country_code: 'US'}).must_equal 2

        address = create(:shipping_address, state_code: 'FL', country_code: 'US')
        ShippingMethod.available_for(25, address).size.must_equal 2
        ShippingMethod.available_for(200, address).size.must_equal 0
      }
    end
    describe "with two shipping methods and make one active" do
      it {
        s1 = create(:country_shipping_method, lower_price_limit: 1, upper_price_limit: 51, name: 'General')
        s2 = create(:country_shipping_method, lower_price_limit: 1, upper_price_limit: 51, active: false, name: 'Express')
        s1.active.must_equal true
        s1.regions.each { |r| r.active.must_equal true }

        s2.active.must_equal false
        s2.regions.each { |r| r.active.must_equal false }

        address = create(:shipping_address, state_code: 'FL', country_code: 'US')
        ShippingMethod.available_for(25, address).size.must_equal 1
        ShippingMethod.available_for(200, address).size.must_equal 0
      }
    end
  end

  describe "of country type" do
    let(:shipping) { build(:country_shipping_method) }

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
    let(:shipping) { create_regional_shipping_method }


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
