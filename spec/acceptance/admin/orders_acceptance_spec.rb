require "test_helper"

class OrdersAcceptanceTest <  ActionDispatch::IntegrationTest

  setup do
    order = build :order, email: nil, shipping_address: nil, shipping_method: nil
    order.save(validate: false)
  end

  test "payment status abandoned" do
    visit admin_path
    click_link 'Orders'

    assert page.has_css?('h1.ns-page-title', text: 'Orders')
    click_link Order.first.number
    assert page.has_content?('Payment status abandoned')
  end

  test "show order with line item and product is deleted" do
    order  =  create :order_with_line_items
    order.line_items.first.product.destroy

    visit admin_path
    click_link 'Orders'

    assert page.has_css?('h1.ns-page-title', text: 'Orders')
    click_link order.number
    assert page.has_content?('Payment status abandoned')
  end

end
