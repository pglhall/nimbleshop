require 'test_helper'

class PaymentProcessorTest < ActiveSupport::TestCase

  def playcasette(casette)
    VCR.use_cassette(casette)  { yield }
  end

  setup do
    @order = create :order
  end

  test "authorization when credit card is invalid" do
    Shop.first.update_attribute(:default_creditcard_action, 'authorize')
    creditcard =  build(:creditcard, number: 2)
    processor = PaymentProcessor.new(creditcard, @order)
    playcasette('authorize.net/authorize-failure') { processor.process }
    assert_equal ['Credit card was declined. Please try again! '], creditcard.errors[:base]
  end

  test "authorization when credit card is valid" do
    Shop.first.update_attribute(:default_creditcard_action, 'authorize')
    creditcard = build(:creditcard)
    processor = PaymentProcessor.new(creditcard, @order)
    playcasette('authorize.net/authorize-success') { processor.process }
    @order.reload
    @order.must_be(:authorized?)
    assert_equal 1, @order.transactions.count
    assert @order.transactions.last.active?
    assert @order.transactions.last.authorized?
    assert_equal PaymentMethod.find_by_permalink('authorize-net'), @order.payment_method
  end

  test 'purchase when credit card is valid' do
    Shop.first.update_attribute(:default_creditcard_action, 'purchase')
    creditcard = build(:creditcard)
    processor = PaymentProcessor.new(creditcard, @order)
    playcasette('authorize.net/purchase-success') { processor.process }
    @order.must_be(:paid?)
    @order.transactions.count.must_equal 1
    @order.transactions.last.must_be(:active?)
    @order.transactions.last.must_be(:purchased?)
    @order.payment_method.must_equal PaymentMethod.find_by_permalink('authorize-net')
  end

  test "purchase when credit card is invalid" do
    Shop.first.update_attribute(:default_creditcard_action, 'purchase')
    creditcard = build(:creditcard, number: 2)
    processor = PaymentProcessor.new(creditcard, @order)
    playcasette('authorize.net/purchase-failure') { processor.process }
    assert_equal ['Credit card was declined. Please try again! '], creditcard.errors[:base]
  end

end
