require 'test_helper'

class CreditcardTest < ActiveModel::TestCase
  test "active merchant should not validate an invalid card" do
    card = Creditcard.new
    assert_nothing_raised { card.valid? }
  end

  test "active merchant should validate a valid card" do
    card = build(:creditcard)
    assert card.valid?
  end
end
