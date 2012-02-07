require 'spec_helper'

describe RegionalShippingZone do
  describe "#validations" do

    it "allows valid state code" do
      country = CountryShippingZone.new(country_code: 'US')
      region  = RegionalShippingZone.new(state_code: 'AL')

      region.country_shipping_zone = country
      region.valid?
      region.errors[:code].must_be(:empty?)
    end

    it "will not allow empty state code" do
      country = CountryShippingZone.new(country_code: 'US')
      region  = RegionalShippingZone.new(state_code: '')

      region.country_shipping_zone = country
      region.valid?
      region.errors[:code].wont_be(:empty?)
      region.errors.full_messages.first.must_equal "State code can't be blank"
    end

    it "will not allow invalid state code" do
      country = CountryShippingZone.new(country_code: 'US')
      region  = RegionalShippingZone.new(state_code: 'XXXX')

      region.country_shipping_zone = country
      region.valid?
      region.errors[:code].wont_be(:empty?)
      region.errors.full_messages.first.must_equal "Code XXXX is an invalid regional code for country United States"
    end


  end
end
