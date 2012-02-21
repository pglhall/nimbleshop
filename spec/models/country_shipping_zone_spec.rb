require 'spec_helper'

describe CountryShippingZone do

  describe "assign name from carmen" do
    it {
      create(:country_shipping_zone).name.must_equal "United States"
    }
  end

  describe "#validations" do
    subject { create(:country_shipping_zone) }

    it do 
      wont allow_value("XXX").for(:country_code)
      must validate_presence_of(:country_code)
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
