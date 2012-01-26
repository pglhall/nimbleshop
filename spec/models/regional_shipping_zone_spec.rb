require 'spec_helper'

describe RegionalShippingZone do
  describe "#validations" do

    it "allows valid state code" do
      country = CountryShippingZone.new(code: 'US') 
      region  = RegionalShippingZone.new(code: 'AL')

      region.country_shipping_zone = country

      region.valid?

      region.errors[:code].must_be(:empty?)
    end

    it "will not allow invalid state code" do
      country = CountryShippingZone.new(code: 'CA') 
      region  = RegionalShippingZone.new(code: 'AL')

      region.country_shipping_zone = country

      region.valid?

      region.errors[:code].wont_be(:empty?)
    end
  end
end
