require 'spec_helper'


describe ApplicationHelper do
  describe "#unconfigured_countries" do
    it "should existing country shipping zones" do
      result = unconfigured_shipping_zone_countries.map {|_,t| t }
      result.must_include 'HK'

      create(:country_shipping_zone, country_code: 'HK')
      result = unconfigured_shipping_zone_countries.map {|_,t| t }
      result.wont_include 'HK'
    end
  end
end
