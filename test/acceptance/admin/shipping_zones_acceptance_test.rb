require 'test_helper'

class ShippingZonesAcceptanceTest < ActionDispatch::IntegrationTest

  test "create new shipping zone and should add state level shipping methods" do
      visit admin_path
      click_link 'Shipping zones'
      click_link 'add_new_shipping_zone'
      bef = RegionalShippingZone.count
      select 'Canada', :from => 'Country name'
      click_button('Submit')
      assert page.has_content?('Successfully created')
      assert_equal 13, RegionalShippingZone.count - bef
  end

end
