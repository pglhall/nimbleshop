require 'spec_helper'

class DummyClass < ActionView::Base
  include ApplicationHelper
end

describe ApplicationHelper do
  def helper
    DummyClass.new
  end

  describe "#unconfigured_countries" do
    it "should existing country shipping zones" do
      result = helper.unconfigured_shipping_zone_countries.map {|_,t| t }
      result.must_include 'HK'
      create(:country_shipping_zone, country_code: 'HK')
      result = helper.unconfigured_shipping_zone_countries.map {|_,t| t }
      result.wont_include 'HK'
    end
  end
end
