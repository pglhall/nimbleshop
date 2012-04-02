require 'spec_helper'

describe "shipping_zones_acceptance_spec integration" do

  def assert_regions_created(count)
    bef = RegionalShippingZone.count
    yield
    assert_equal count, RegionalShippingZone.count - bef
  end

  describe "should add state level shipping methods when new shipping zone is created" do
    it {
      visit admin_path
      click_link 'Shipping zones'
      click_link 'add_new_shipping_zone'
      assert_regions_created(13) do
        select 'Canada', :from => 'Country name'
        click_button('Submit')
        assert page.has_content?('Successfuly created')
      end
    }
  end
end

