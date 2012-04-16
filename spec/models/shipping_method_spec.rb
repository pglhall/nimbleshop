require "test_helper"

class ShippingMethodTest < ActiveSupport::TestCase
  include RegionalShippingMethodTestHelper

  test "validations" do
    s = create(:country_shipping_method, higher_price_limit: 20)
    s.lower_price_limit = 19
    assert s.valid?

    s.lower_price_limit = 20
    refute s.valid?

    s.lower_price_limit = 21
    refute s.valid?
  end

end

class ShippingMethodScopesTest < ActiveSupport::TestCase
  include ::RegionalShippingMethodTestHelper

  def with_regions(countries)
    countries + countries.map(&:regions).flatten
  end

  def assert_data_exists_in_result(data, result)
    assert (data.map(&:id) - result.map(&:id)).blank?
  end

  setup do
    @us = create(:country_shipping_zone, country_code: 'US')
    @ca = create(:country_shipping_zone, country_code: 'CA')
    @hk = create(:country_shipping_zone, country_code: 'HK')

    @usground1  = create(:shipping_method, lower_price_limit: 0, higher_price_limit: nil, base_price: 3.99, shipping_zone: @us)
    @usair1     = create(:shipping_method, lower_price_limit: 0, higher_price_limit: 600, base_price: 8.99, shipping_zone: @us)
    @hkground1  = create(:shipping_method, lower_price_limit: 100, higher_price_limit: 1000, base_price: 8.99, shipping_zone: @hk)
    @caground1  = create(:shipping_method, lower_price_limit: 0, higher_price_limit: 700, base_price: 5.99, shipping_zone: @ca)
    @hkair1     = create(:shipping_method, lower_price_limit: 900, higher_price_limit: 2000, base_price: 28.99, shipping_zone: @hk)
  end

  test "#in_price_range - knows in which shipping methods are available" do
    assert_data_exists_in_result with_regions([@hkair1, @usground1]) , ShippingMethod.in_price_range(1500).to_ary
  end

  test "#atmost - knows who price is less than the given amount" do
    assert_data_exists_in_result with_regions([ @usground1, @hkground1, @hkair1]), ShippingMethod.atmost(1000).to_ary
    assert_data_exists_in_result with_regions([ @usground1, @usair1, @hkground1, @caground1, @hkair1]), ShippingMethod.atmost(0).to_ary
  end

  test "#aleast - knows who price is greater than the given amount" do
    assert_data_exists_in_result with_regions([ @usground1, @usair1, @caground1]), ShippingMethod.atleast(10).to_ary
  end

  test "#in_country - knows by country code" do
    assert_data_exists_in_result with_regions([@usground1, @usair1]) , ShippingMethod.in_country('US').to_ary
  end

  test "#available_countries" do
    ShippingMethod.available_for_countries(1000).must_have_same_elements ['US', 'HK']
  end
end

class ShippingMethodMiscTest < ActiveSupport::TestCase
  include RegionalShippingMethodTestHelper

  test "making country level shipping method inactive should make children inactive - updating record" do
    shipping_method = create(:country_shipping_method)
    region = shipping_method.regions.first
    region.active.must_equal true
    shipping_method.update_attributes!(active: false)
    region.reload
    region.active.must_equal false
  end

  test "making country level shipping method inactive should make children inactive - creating record" do
    shipping_method = create(:country_shipping_method, active: false)
    region = shipping_method.regions.first
    region.active.must_equal false
  end

  test "#enable! #disable!" do
    shipping = create(:country_shipping_method)

    shipping.enable!
    shipping.must_be(:active)

    shipping.disable!
    shipping.wont_be(:active)
  end

  test "of country - is not going to update" do
    shipment = ShippingMethod.new(base_price: 10)
    shipment.shipping_zone = CountryShippingZone.new
    shipment.update_offset(0.20)
    shipment.offset.to_f.must_equal 0.0
  end
  
  test "#update_offset - of state - is going to increase by 0.20" do
    shipment = ShippingMethod.new(base_price: 10)
    shipment.shipping_zone = RegionalShippingZone.new
    shipment.update_offset(0.20)
    shipment.offset.to_f.must_equal 0.20
  end

  test "#update_offset - of state - is going to decreate by 0.20" do
    shipment = ShippingMethod.new(base_price: 10)
    shipment.shipping_zone = RegionalShippingZone.new
    shipment.offset = 0.80
    shipment.update_offset(-0.20)
    shipment.offset.to_f.must_be_within_delta 0.60
  end

  test "of country type - #shipping_price - ignores offset value" do
    shipping = build(:country_shipping_method)
    shipping.offset = 0.10
    shipping.base_price = 10
    shipping.shipping_price.must_equal 10.0
  end

  test "of country type - on create #callbacks - creates all regional shipping zone records" do
    shipping = build(:country_shipping_method)
    shipping.save
    shipping.regions.count.must_equal 57
  end

  describe "of state type - #shipping_price - ignores base_price value" do
    shipping = create_regional_shipping_method
    shipping.parent.base_price = 10
    shipping.offset = 0.10
    shipping.base_price = 20

    shipping.shipping_price.to_f.must_equal 10.10
  end

  test "of state type - on create #callbacks - does not create all regional shipping zone records" do
    shipping = create_regional_shipping_method
    shipping.save
    shipping.regions.count.must_equal 0
  end

end

require 'spec_helper'

describe ShippingMethod do
  include RegionalShippingMethodTestHelper

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

end
