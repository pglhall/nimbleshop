require 'spec_helper'

describe Order do
  describe "#final_billing_address" do
    let(:order) do
      Order.new(billing_address: billing, shipping_address: shipping)
    end

    describe "when shipping address is nil" do
      let(:shipping)  { nil }
      let(:billing)   { nil }

      it { order.final_billing_address.must_equal nil }
    end

    describe "when shipping address used_for_billing" do
      let(:shipping)  { ShippingAddress.new(use_for_billing: true) }
      let(:billing)   { BillingAddress.new }

      it { order.final_billing_address.must_equal shipping }
    end

    describe "shipping address is not used_for_billing" do
      let(:shipping)  { ShippingAddress.new(use_for_billing: false) }
      let(:billing)   { BillingAddress.new }

      it { order.final_billing_address.must_equal billing }
    end
  end

  describe "products" do
    let(:order)     { create(:order) }
    let(:product1)  { create(:product, price: 10) }
    let(:product2)  { create(:product, price: 30) }
    let(:line_item) { order.line_item_of(product1) }

    it "#add" do
      order.add(product1)
      line_item.product.must_equal product1
      line_item.quantity.must_equal 1
    end

    it "#remove" do
      order.add(product1)
      order.remove(product1)

      line_item.must_equal nil
    end

    it "#set_quantity" do
      order.add(product1)
      order.set_quantity(product1, 20)
      line_item.quantity.must_equal 20
    end

    describe "#price" do
      it "no products" do
        order.line_items_total.to_f.must_equal 0.0
      end

      it "with products" do
        order.add(product1)
        order.add(product2)
        order.set_quantity(product1.id, 3)

        order.line_items_total.to_f.must_equal 60.0
      end
    end
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

  describe "#transaction_authorized" do
    before do
      @order = create(:order)
    end

    it "must verify payment method" do
      @order.transaction_authorized

      @order.errors[:payment_method].must_equal ["can't be blank"]
      Order.find(@order.id).must_be(:abandoned?)
    end

    it "must update shipping state to pending" do
      create(:creditcard_transaction, order: @order)
      @order.update_attributes(payment_method: PaymentMethod::AuthorizeNet.first)

      @order = Order.find(@order.id)
      ActionMailer::Base.deliveries.clear
      @order.transaction_authorized

      @order = Order.find(@order.id)
      @order.must_be(:authorized?)
      @order.must_be(:shipping_pending?)
      ActionMailer::Base.deliveries.count.must_equal 2
    end
  end

  describe "#transaction_captured" do
    it {
      @order = create(:authorized_order)
      @order.transaction_captured

      Order.find(@order.id).must_be(:paid?)
    }
  end

  describe "#transaction_purchased" do
    it {
      @order = create(:order_with_transaction)
      ActionMailer::Base.deliveries.clear
      @order.transaction_purchased

      @order = Order.find(@order.id)
      @order.must_be(:paid?)
      @order.must_be(:shipping_pending?)
      @order.splitable_paid_at.must_equal(@order.updated_at.to_s(:long))
      ActionMailer::Base.deliveries.count.must_equal 2
    }
  end

  describe "#transaction_cancelled" do
    it {
      @order = create(:authorized_order)
      @order.transaction_cancelled

      Order.find(@order.id).must_be(:cancelled?)
    }
  end

  describe "#transaction_refunded" do
    it {
      @order = create(:captured_order)
      @order.transaction_refunded

      Order.find(@order.id).must_be(:refunded?)
    }
  end
end
