require 'spec_helper'

describe CountryShippingZone do

  describe "assign name from carmen" do
    it {
      create(:country_shipping_zone).name.must_equal "United States"
      RegionalShippingZone.count.must_equal 57
    }
  end

  describe "testing that factory take country_code takes override" do
    it {
      create(:country_shipping_zone, country_code: 'IN').name.must_equal "India"
    }
  end

  describe "#validations" do
    it "should not accept wrong country code" do
      zone = build(:country_shipping_zone, country_code: 'XXX')
      zone.valid?
      zone.errors[:country_code].wont_be(:empty?)
      zone.errors.full_messages.sort.first.must_equal "Country code is invalid"
    end

    it "ensures that country code is required" do
      zone = CountryShippingZone.new
      zone.valid?
      zone.errors[:country_code].wont_be(:empty?)
      zone.errors.full_messages.sort.first.must_equal "Country code can't be blank"
    end
  end

  describe "#callbacks" do
    it "should create all regions from canada" do
      canada  = create(:country_shipping_zone, country_code: 'CA')
      regions = Carmen::Country.coded("CA").subregions
      canada.regional_shipping_zones.length.must_equal regions.length
    end

    it "should create all regions for USA" do
      usa     = create(:country_shipping_zone, country_code: 'US')
      regions = Carmen::Country.coded("US").subregions
      usa.regional_shipping_zones.length.must_equal regions.length
    end
  end

end
