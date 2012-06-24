require "test_helper"

class ShippingMethodTest < ActiveSupport::TestCase
  include RegionalShippingMethodTestHelper

  test "validations" do
    s = create(:country_shipping_method, higher_price_limit: 20)
    s.minimum_order_amount = 19
    assert s.valid?

    s.minimum_order_amount = 20
    refute s.valid?

    s.minimum_order_amount = 21
    refute s.valid?
  end

  test 'validations round2' do
    s = build(:country_shipping_method, minimum_order_amount:0, higher_price_limit: 0)
    s.valid?
    assert_equal 'Maximum order amount must be greater than 0', s.errors.full_messages.first
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

    @usground1  = create(:shipping_method, minimum_order_amount: 0, higher_price_limit: nil, base_price: 3.99, shipping_zone: @us)
    @usair1     = create(:shipping_method, minimum_order_amount: 0, higher_price_limit: 600, base_price: 8.99, shipping_zone: @us)
    @hkground1  = create(:shipping_method, minimum_order_amount: 100, higher_price_limit: 1000, base_price: 8.99, shipping_zone: @hk)
    @caground1  = create(:shipping_method, minimum_order_amount: 0, higher_price_limit: 700, base_price: 5.99, shipping_zone: @ca)
    @hkair1     = create(:shipping_method, minimum_order_amount: 900, higher_price_limit: 2000, base_price: 28.99, shipping_zone: @hk)
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
    assert_sorted_equal ShippingMethod.available_for_countries(1000).sort, ['US', 'HK'].sort
  end
end

class ShippingMethodMiscTest < ActiveSupport::TestCase
  include RegionalShippingMethodTestHelper

  test "making country level shipping method inactive should make children inactive - updating record" do
    shipping_method = create(:country_shipping_method)
    region = shipping_method.regions.first
    assert region.active
    shipping_method.update_attributes!(active: false)
    region.reload
    refute region.active
  end

  test "making country level shipping method inactive should make children inactive - creating record" do
    shipping_method = create(:country_shipping_method, active: false)
    region = shipping_method.regions.first
    refute region.active
  end

  test "#enable! #disable!" do
    shipping = create(:country_shipping_method)

    shipping.enable!
    assert shipping.active

    shipping.disable!
    refute shipping.active
  end

  test "of country - is not going to update" do
    shipment = ShippingMethod.new(base_price: 10)
    shipment.shipping_zone = CountryShippingZone.new
    shipment.update_offset(0.20)
    assert_equal 0.0, shipment.offset.to_f
  end

  test "#update_offset - of state - is going to increase by 0.20" do
    shipment = ShippingMethod.new(base_price: 10)
    shipment.shipping_zone = RegionalShippingZone.new
    shipment.update_offset(0.20)
    assert_equal 0.20, shipment.offset.to_f
  end

  test "#update_offset - of state - is going to decreate by 0.20" do
    shipment = ShippingMethod.new(base_price: 10)
    shipment.shipping_zone = RegionalShippingZone.new
    shipment.offset = 0.80
    shipment.update_offset(-0.20)
    assert_in_delta 0.60, shipment.offset.to_f
  end

  test "of country type - #shipping_price - ignores offset value" do
    shipping = build(:country_shipping_method)
    shipping.offset = 0.10
    shipping.base_price = 10
    assert_equal 10.0, shipping.shipping_price
  end

  test "of country type - on create #callbacks - creates all regional shipping zone records" do
    shipping = build(:country_shipping_method)
    shipping.save
    assert_equal 57, shipping.regions.count
  end

  test "of state type - #shipping_price - ignores base_price value" do
    shipping = create_regional_shipping_method
    shipping.parent.base_price = 10
    shipping.offset = 0.10
    shipping.base_price = 20

    assert_equal 10.10, shipping.shipping_price.to_f
  end

  test "of state type - on create #callbacks - does not create all regional shipping zone records" do
    shipping = create_regional_shipping_method
    shipping.save
    assert_equal 0, shipping.regions.count
  end

end

class A < ActiveSupport::TestCase
  include RegionalShippingMethodTestHelper

  setup do
    CountryShippingZone.delete_all
    RegionalShippingZone.delete_all
  end

  test "#available_for - with one shipping method" do
    shipping_method = create(:country_shipping_method, minimum_order_amount: 10, maximum_order_amount: 51)
    assert_equal 1, CountryShippingZone.count
    assert_equal 57, RegionalShippingZone.count
    assert_equal 'US', shipping_method.shipping_zone.country_code

    address = create(:shipping_address, state_code: 'FL', country_code: 'US')
    assert_equal 'FL', address.state_code
    assert_equal 1, RegionalShippingZone.count(conditions: {state_code: 'FL', country_code: 'US'})

    assert_equal 1, ShippingMethod.available_for(25, address).size
    assert_equal 0, ShippingMethod.available_for(200, address).size
  end

  test "#available_for - with two shipping methods" do
    create(:country_shipping_method, minimum_order_amount: 10, maximum_order_amount: 51, name: 'General')
    create(:country_shipping_method, minimum_order_amount: 10, maximum_order_amount: 51, name: 'Express')
    assert_equal 2, RegionalShippingZone.count(conditions: {state_code: 'FL', country_code: 'US'})

    address = create(:shipping_address, state_code: 'FL', country_code: 'US')
    assert_equal 2, ShippingMethod.available_for(25, address).size
    assert_equal 0, ShippingMethod.available_for(200, address).size
  end

  test "#available_for - with two shipping methods and make one active" do
    s1 = create(:country_shipping_method, minimum_order_amount: 1, maximum_order_amount: 51, name: 'General')
    s2 = create(:country_shipping_method, minimum_order_amount: 1, maximum_order_amount: 51, active: false, name: 'Express')
    assert s1.active
    s1.regions.each { |r| assert r.active }

    refute s2.active
    s2.regions.each { |r| refute r.active }

    address = create(:shipping_address, state_code: 'FL', country_code: 'US')
    assert_equal 1, ShippingMethod.available_for(25, address).size
    assert_equal 0, ShippingMethod.available_for(200, address).size
  end

end
