require 'spec_helper'

describe RegionalShippingZone do
  describe "#validations" do
    let(:us) { create(:country_shipping_zone, country_code: "US") }
    subject { us.regional_shipping_zones.find_by_state_code("FL") } 

    it {
      must validate_presence_of(:state_code)
      wont allow_value("BAD").for(:state_code)
      wont allow_value("AZ").for(:state_code)

      us.regional_shipping_zones.find_by_state_code("AL").delete

      must allow_value("AL").for(:state_code)
    }
  end
end
