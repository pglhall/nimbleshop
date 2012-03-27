require 'spec_helper'

describe "Shipping zone integration" do

  def assert_regions_created(count)
    bef = RegionalShippingZone.count
    yield
    assert_equal count, RegionalShippingZone.count - bef
  end

  describe "should add state level shipping methods when new shipping zone is added" do
    it {
      visit new_admin_shipping_zone_path
      assert_regions_created(13) do
        select 'Canada', :from => 'Country name'
        click_button('Submit')
        page.must_have_content('Successfuly created')
      end
    }
  end
end
