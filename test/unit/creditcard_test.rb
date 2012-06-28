require 'test_helper'

class CreditcardTest < ActiveModel::TestCase

  test 'active merchant should not validate an invalid card' do
    card = Creditcard.new
    refute card.valid?
  end

  test 'active merchant should validate a valid card' do
    card = build(:creditcard)
    assert card.valid?
  end

  test 'error message when number is nil' do
    card = build(:creditcard, number: nil)
    refute card.valid?
    assert_equal 'Please enter credit card number', card.errors.full_messages.first
  end

  test 'error message when number is not numeric' do
    card = build(:creditcard, number: 'a')
    refute card.valid?
    assert_equal 'Please check the credit card number you entered', card.errors.full_messages.first
  end

  test 'error message when cvv is nil' do
    card = build(:creditcard, cvv: nil)
    refute card.valid?
    assert_equal 'Please enter CVV', card.errors.full_messages.first
  end

end
