require 'test_helper'

class PaymentProcessorHelperTest < ActionView::TestCase

  test "return_url for order" do
    order = Order.new
    order.number = 23
    expected = 'https://orange-hands.showoff.io/orders/23/paypal'

    assert_equal return_url(order), expected
  end

  test "cancel_url for order" do
    order = Order.new
    order.number = 23
    expected = 'https://orange-hands.showoff.io/orders/23/cancel'

    assert_equal cancel_url(order), expected
  end

  test "notify_url for paypal ipn" do
    expected = 'https://orange-hands.showoff.io/instant_payment_notifications/paypal'
    assert_equal notify_url, expected
  end
end
