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

  describe "should remove already created countries" do
    it {
      visit new_admin_shipping_zone_path
      select 'Canada', :from => 'Country name'
      click_button('Submit')
      visit new_admin_shipping_zone_path
      page.wont_have_xpath "//select[@id = 'shipping_zone_country_code']/option[@value = 'CA']"
    }
  end
end
