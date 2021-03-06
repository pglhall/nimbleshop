require "test_helper"

class OrdersAcceptanceTest <  ActionDispatch::IntegrationTest

  test "paid using splitable" do
    order = create(:order_paid_using_splitable, payment_status: 'purchased')

    visit admin_path
    click_link 'Orders'

    click_link order.number
    assert page.has_content?('Splitable')
  end

  test "paid using paypalwp" do
    order = create(:order_paid_using_paypalwp, payment_status: 'purchased')

    visit admin_path
    click_link 'Orders'

    click_link order.number
    assert page.has_content?('Paypal website payments standard')
  end

  test "paid using authorize.net" do
    order = create(:order_paid_using_authorizedotnet, payment_status: 'authorized')

    visit admin_path
    click_link 'Orders'

    click_link order.number
    assert page.has_content?('Authorize.net')
    assert page.has_content?('Payment status AUTHORIZED')
  end

  test "payment status abandoned" do
    order = build :order, email: nil, shipping_address: nil, shipping_method: nil
    order.save(validate: false)

    visit admin_path
    click_link 'Orders'

    assert page.has_css?('h1.ns-page-title', text: 'Orders')
    click_link Order.first.number
    assert page.has_content?('Payment status ABANDONED')
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
    assert page.has_content?('Payment status ABANDONED')
  end

end
