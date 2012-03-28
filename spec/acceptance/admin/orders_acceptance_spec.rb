require 'spec_helper'

describe "orders_acceptance_spec integration" do

  describe "order with no extra information" do
    before do
      order = build :order, email: nil, shipping_address: nil, shipping_method: nil
      order.save(validate: false)
    end
    it {
      visit admin_path
      click_link 'Orders'

      page.has_css?('h1.ns-page-title', text: 'Orders')
      click_link Order.first.number
      assert page.has_content?('Payment status abandoned')
    }
  end

  describe "order with line item and product is deleted" do
    it {
      order   =  create(:order_with_line_items)
      order.line_items.first.product.destroy

      visit admin_path
      click_link 'Orders'

      page.has_css?('h1.ns-page-title', text: 'Orders')
      click_link order.number
      assert page.has_content?('Payment status abandoned')
    }
  end

end
