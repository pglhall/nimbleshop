require 'spec_helper'

describe "admin integration" do
  describe "order with no extra information" do
    it {
      order = create(:order)
      order.email = nil
      order.shipping_address = nil
      order.shipping_method = nil
      order.save(validate: false)

      visit admin_orders_path

      page.has_css?('h1.ns-page-title', text: 'Orders')
      click_link Order.first.number
      save_and_open_page

      assert page.has_content?('Payment status abandoned')
    }
  end
end
