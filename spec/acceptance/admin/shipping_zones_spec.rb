require 'spec_helper'

describe "Shipping Method integration" do

  def assert_regions_created(count)
    bef = RegionalShippingZone.count
    yield
    assert_equal count, RegionalShippingZone.count - bef 
  end

  describe "Adding new shipping zone" do
    it "should add state level shipping methods" do
      visit new_admin_shipping_zone_path
      assert_regions_created(13) do 
        select 'Canada', :from => 'Name' 
        click_button('Submit')
        page.has_content?('created')
      end
    end
  end

  describe "Dropping shipping zone" do
    it "should add state level shipping methods" do
      visit admin_shipping_zones_path
      click_link "Add new shipping zone"
    end
  end
end
