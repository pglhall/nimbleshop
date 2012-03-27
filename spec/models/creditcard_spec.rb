require 'test_helper'

class CreditcardTest < ActiveSupport::TestCase

  test "wont validate by active merchant if card is invalid" do
    card = Creditcard.new
    assert_nothing_raised { card.valid? }
  end

  test "validate by active merchant if card is valid" do
    card = build(:creditcard)

    assert card.valid?
  end
end
