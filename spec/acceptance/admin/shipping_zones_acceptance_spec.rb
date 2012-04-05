require 'spec_helper'

describe "shipping_zones_acceptance_spec integration" do

  describe "create new shipping zone and should add state level shipping methods" do
    it {
      visit admin_path
      click_link 'Shipping zones'
      click_link 'add_new_shipping_zone'
      bef = RegionalShippingZone.count
      select 'Canada', :from => 'Country name'
      click_button('Submit')
      assert page.has_content?('Successfuly created')
      assert_equal count, RegionalShippingZone.count - bef
    }
  end

end

