require 'test_helper'

class RegionalShippingZoneTest < ActiveRecord::TestCase
  test "validate presence of name" do
    zone = RegionalShippingZone.new

    assert zone.invalid?
    assert_equal ["can't be blank"], zone.errors[:state_code]
  end
end
