require 'spec_helper'

describe Order do

  describe "validations" do
    subject { create(:order) }
    it {

    }
  end

  describe '#available_shipping_methods' do
    it {
      order = create(:order)
      order.add(create(:product))
      shipping_method = create(:country_shipping_method, base_price: 100, lower_price_limit: 1, upper_price_limit: 99999)
      order.shipping_address = create(:shipping_address)
      order.available_shipping_methods.size.must_equal 1
    }
  end

  describe '#set_quantity' do
    it {
      order = create(:order)
      product = create(:product)
      order.add(product)
      order.set_quantity(product, 3)
    }
  end

  describe "#after_authorized" do
    it {
      order = create(:order)
      create(:creditcard_transaction, order: order)
      order.authorized
      order.payment_status.must_equal 'authorized'
      ActionMailer::Base.deliveries.size.must_equal 2

      mail = ActionMailer::Base.deliveries.first
      mail.subject.must_equal "Order confirmation for order ##{order.number}"
      mail.encoded.must_match /Here is receipt for your purchase/
      mail.encoded.must_match /When items are shipped you will get an email with tracking number/

      mail = ActionMailer::Base.deliveries.last
      mail.subject.must_equal "Order ##{order.number} was recently placed"
      mail.encoded.must_match Regexp.new("Order ##{order.number} was placed by")
    }
  end

end
