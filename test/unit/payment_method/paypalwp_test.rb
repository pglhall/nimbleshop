require 'test_helper'

class PaymentMethodPaypalwpTest < ActiveSupport::TestCase

  test "validations" do
    pm = NimbleshopPaypalwp::Paypalwp.new(name: 'Paypalwp', description: 'this is description')
    refute pm.valid?
    assert_equal ["Merchant email is invalid"], pm.errors.full_messages.sort
  end

  test "should save the record" do
    pm = NimbleshopPaypalwp::Paypalwp.new(name: 'Paypalwp', merchant_email: 'merchant@example.com', description: 'this is description')
    assert pm.save
    assert_match /paypalwp/, pm.permalink
  end

end
