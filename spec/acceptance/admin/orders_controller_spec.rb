require 'spec_helper'

describe "admin integration" do

  describe "order with no extra information" do
    before do
      order = create(:order)
      order.email = nil
      order.shipping_address = nil
      order.shipping_method = nil
      order.save(validate: false)
    end
    it {
      visit admin_orders_path
      page.has_css?('h1.ns-page-title', text: 'Orders')
      click_link Order.first.number
      assert page.has_content?('Payment status abandoned')
    }
  end

  describe "order with line item" do
    it {
      order_with_line_items
      order = Order.first
      product = Product.find(order.line_items.first.product_id)
      product.destroy

      visit admin_orders_path
      page.has_css?('h1.ns-page-title', text: 'Orders')
      click_link Order.first.number
      assert page.has_content?('Payment status abandoned')
    }
  end

end
