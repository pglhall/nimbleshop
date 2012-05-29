require "test_helper"

class OrdersAcceptanceTest <  ActionDispatch::IntegrationTest

  test "paid using authorize.net" do
    payment_transaction = PaymentTransaction.find_by_id(1)
    order = create(:order_paid_using_authorizedotnet, payment_status: 'authorized')
    payment_transaction.update_attribute(:order_id, order.id)

    visit admin_path
    click_link 'Orders'

    click_link Order.first.number
    save_and_open_page
    assert page.has_content?('Authorize.net')
    assert page.has_content?('Payment status authorized')
  end

  test "payment status abandoned" do
    order = build :order, email: nil, shipping_address: nil, shipping_method: nil
    order.save(validate: false)

    visit admin_path
    click_link 'Orders'

    assert page.has_css?('h1.ns-page-title', text: 'Orders')
    click_link Order.first.number
    assert page.has_content?('Payment status abandoned')
  end

  test "show order with line item and product is deleted" do
    order = build :order, email: nil, shipping_address: nil, shipping_method: nil
    order.save(validate: false)

    order  =  create :order_with_line_items
    order.line_items.first.product.destroy

    visit admin_path
    click_link 'Orders'

    assert page.has_css?('h1.ns-page-title', text: 'Orders')
    click_link order.number
    assert page.has_content?('Payment status abandoned')
  end

end
