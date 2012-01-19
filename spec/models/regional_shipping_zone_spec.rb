require 'spec_helper'

describe RegionalShippingZone do
  describe "#validations" do

    it "allows valid state code" do
      country = CountryShippingZone.new(carmen_code: 'US') 
      region  = RegionalShippingZone.new(carmen_code: 'AL')

      region.country_shipping_zone = country

      region.valid?

      region.errors[:carmen_code].must_be(:empty?)
    end

    it "will not allow invalid state code" do
      country = CountryShippingZone.new(carmen_code: 'CA') 
      region  = RegionalShippingZone.new(carmen_code: 'AL')

      region.country_shipping_zone = country

      region.valid?

      region.errors[:carmen_code].wont_be(:empty?)
    end
  end
end
