require 'test_helper'

class PaymentConfirmationAcceptanceTest < ActionDispatch::IntegrationTest

  test "show order when it was paid using splitable" do
    order = create :order_paid_using_splitable
    visit "/orders/#{order.number}" #order_path(order)
    assert page.has_content?('Purchase is complete')
  end

  test "show order when it was paid using paypalwp" do
    order = create :order_paid_using_paypalwp
    visit "/orders/#{order.number}" #order_path(order)
    assert page.has_content?('Purchase is complete')
  end

  test "show order when it was paid using authorizedotnet" do
    order = create :order_paid_using_authorizedotnet
    visit "/orders/#{order.number}" #order_path(order)
    assert page.has_content?('Purchase is complete')
    assert page.has_content?('In the credit card statement name of the company would appear as Nimbleshop LLC')
  end

end
