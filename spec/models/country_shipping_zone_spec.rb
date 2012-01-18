require 'spec_helper'

describe CountryShippingZone do
  describe "#validations" do

    it "should succed on valid carmen country code" do
      zone = CountryShippingZone.new(carmen_code: 'US')
      zone.valid?

      zone.errors[:carmen_code].must_be(:empty?)
    end

    it "raise errors on invalid carmen country code" do
      zone = CountryShippingZone.new(carmen_code: 'ZZ')
      zone.valid?

      zone.errors[:carmen_code].wont_be(:empty?)
    end

    it "raise errors on nil carmen code" do
      zone = CountryShippingZone.new
      zone.valid?

      zone.errors[:carmen_code].wont_be(:empty?)
    end
  end
end
