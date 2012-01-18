require 'spec_helper'

describe ShippingZone do
  describe "validations" do

    it "raise errors on invalid carmen coutnry codes" do
      zone = ShippingZone.new(country_code: 'ZZ')
      zone.valid?

      zone.errors[:country_code].wont_be(:empty?)
    end

    it "raise errors on nil coutnry code" do
      zone = ShippingZone.new
      zone.valid?

      zone.errors[:country_code].wont_be(:empty?)
    end
  end
end
