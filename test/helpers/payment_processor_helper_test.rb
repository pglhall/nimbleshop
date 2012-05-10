require 'test_helper'

class PaymentProcessorHelperTest < ActionView::TestCase
  setup do
    @base_public_url =  'orange-hands.showoff.io'

    File.open("#{Rails.root}/config/tunnel","w") do | out |
      out.write(@base_public_url)
    end
  end

  test "return_url for order" do
    order = Order.new
    order.number = 23

    assert_equal "https://#{@base_public_url}/orders/23/paypal", return_url(order)
  end

  test "cancel_url for order" do
    order = Order.new
    order.number = 23

    assert_equal "https://#{@base_public_url}/orders/23/cancel", cancel_url(order)
  end

  test "notify_url for paypal ipn" do
    assert_equal "https://#{@base_public_url}/admin/payment_methods/paypal_extension/paypal/notify", notify_url
  end

end
