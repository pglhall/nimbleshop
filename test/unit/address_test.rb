require 'test_helper'

class AddressTest < ActiveRecord::TestCase

  test "#country_name" do
    address = create(:address, country_code: 'IN', state_code: 'AP')
    assert_equal 'India', address.country_name
  end

  test "#state_name" do
    address = create(:address, country_code: 'US', state_code: 'MD')
    assert_equal 'United States', address.country_name
    assert_equal 'Maryland', address.state_name
  end

  test "state code is required" do
    address = build(:address, country_code: 'BR', state_code: nil, state_name: nil)
    address.valid?
    assert_equal "State code is required", address.errors.full_messages.first
  end

  test "state code must be valid" do
    address = build(:address, country_code: 'BR', state_code: 'XX')
    address.valid?
    assert_equal "State code XX is not a valid state", address.errors.full_messages.first
  end

  test "#to_credit_card_attributes" do
    options = Address.new.to_credit_card_attributes
    assert_equal ["address1", "address2", "first_name", "last_name", "state", "zipcode"], options.keys.sort
  end

end
