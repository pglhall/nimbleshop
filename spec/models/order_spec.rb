require 'spec_helper'

describe Order do

  describe "inquirer methods" do
    let(:order) do 
      Order.new(shipping_status: 'nothing_to_ship', payment_status: 'purchased', status: 'open')
    end

    it "kind of string inquirer" do
      order.shipping_status.must_be_kind_of ActiveSupport::StringInquirer
      order.payment_status.must_be_kind_of ActiveSupport::StringInquirer
      order.status.must_be_kind_of ActiveSupport::StringInquirer
     end

    it "reflect current values" do
      order.shipping_status = 'shipped'
      order.shipping_status.must_be(:shipped?)

      order.status.must_be(:open?)
      order.status = 'closed'
      order.status.must_be(:closed?)

      order.payment_status.must_be(:purchased?)
      order.payment_status = 'captured'
      order.payment_status.must_be(:captured?)
    end
  end

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

  describe "authorized" do
    let(:order) { order_with_authorized_transaction }

    it {
      order.authorized
      order.reload
      order.payment_method.name.must_equal 'Authorize.net'
      order.payment_status.must_equal 'authorized'
      ActionMailer::Base.deliveries.size.must_equal 2
      order.shipping_status.must_equal 'shipping_pending'

      mail = ActionMailer::Base.deliveries.first
      mail.subject.must_equal "Order confirmation for order ##{order.number}"
      mail.encoded.must_match /Here is receipt for your purchase/
      mail.encoded.must_match /When items are shipped you will get an email with tracking number/

      mail = ActionMailer::Base.deliveries.last
      mail.subject.must_equal "Order ##{order.number} was recently placed"
      mail.encoded.must_match Regexp.new("Order ##{order.number} was placed by")
    }
  end

  describe "captured" do
    let(:order) { order_with_authorized_transaction }

    it {
      order.authorized
      order.captured
      order.reload
      order.payment_method.name.must_equal 'Authorize.net'
      order.payment_status.must_equal 'paid'
      order.shipping_status.must_equal 'shipping_pending'
    }
  end

  describe "purchased" do
    it {
      order = create(:order)
      order.update_attributes!(payment_method: PaymentMethod::Splitable.first)
      order.purchased
      order.reload
      order.payment_method.name.must_equal 'Splitable'
      order.payment_status.must_equal 'paid'
      order.shipping_status.must_equal 'shipping_pending'
    }
  end

  describe "cancelled" do
    describe "at initial state" do
      it {
        order = create(:order)
        order.cancelled
        order.reload
        order.payment_status.must_equal 'abandoned' # abandonded orders cannot be cancelled
        order.shipping_status.must_equal 'nothing_to_ship'
      }
    end

    describe "after authorized" do
      let(:order) { order_with_authorized_transaction }

      it {
        order.authorized
        order.cancelled
        order.reload
        order.payment_status.must_equal 'cancelled'
        order.shipping_status.must_equal 'nothing_to_ship'
      }
    end
  end

  describe "refunded" do
    let(:order) { order_with_authorized_transaction }

    describe "after captured" do
      it {
        order.authorized
        order.captured
        order.refunded
        order.reload
        order.payment_status.must_equal 'refunded'
        order.shipping_status.must_equal 'nothing_to_ship'
      }
    end
    describe "after authorized" do
      it {
        order.authorized
        order.refunded
        order.reload
        order.payment_status.must_equal 'authorized' # only captured transactions can be refunded
        order.shipping_status.must_equal 'shipping_pending'
      }
    end
  end

end


