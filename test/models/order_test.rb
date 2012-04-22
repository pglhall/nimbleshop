require 'test_helper'

class OrderAddressTest < ActiveSupport::TestCase

  test "shipping and billing address is nil" do
    order = Order.new(billing_address: nil, shipping_address: nil)
    assert_equal nil, order.final_billing_address
  end

  test "billing address is same as shipping address" do
    shipping_address = ShippingAddress.new(use_for_billing: true)
    order = Order.new(shipping_address: shipping_address, billing_address: BillingAddress.new)
    assert_equal shipping_address, order.final_billing_address
  end

  test "billing address is different from shipping address" do
    shipping_address = ShippingAddress.new(use_for_billing: false)
    billing_address = BillingAddress.new
    order = Order.new(shipping_address: shipping_address, billing_address: billing_address)
    assert_equal billing_address, order.final_billing_address
  end

end

class OrderTest < ActiveSupport::TestCase
  setup do
    @order = create :order
    @product1 = create :product, price: 10
    @product2 = create :product, price: 30
  end

  test "#add" do
    @order.add(@product1)
    assert_equal 1, @order.line_items.size
    assert_equal 1, @order.line_items.first.quantity
  end

  test "#remove" do
    @order.add(@product1)
    @order.remove(@product1)
    assert @order.reload.line_items.empty?
    assert_equal 0.0, @order.reload.line_items_total.to_f
  end

  test "#set_quantity" do
    @order.add(@product1)
    @order.set_quantity(@product1, 20)
    assert_equal 20, @order.line_items.first.quantity
  end

  test "price when more items are in the order" do
    @order.add(@product1)
    @order.add(@product2)
    @order.set_quantity(@product1.id, 3)
    assert_equal 60.0, @order.line_items_total.to_f
  end

  test "#available_shipping_methods" do
    @order.add(create(:product))
    shipping_method = create(:country_shipping_method, base_price: 100, lower_price_limit: 1, upper_price_limit: 99999)
    @order.shipping_address = create(:shipping_address)
    assert_equal 1, @order.available_shipping_methods.size
  end
end

class OrderPaymentTest < ActiveSupport::TestCase
  setup do
    @order = create :order
  end

  test "payment_method is required" do
    @order.transaction_authorized
    assert_equal ["can't be blank"], @order.errors[:payment_method]
    assert Order.find(@order.id).abandoned?
  end

   test "#transaction_authorized" do
    create(:creditcard_transaction, order: @order)
    @order.update_attributes(payment_method: PaymentMethod::AuthorizeNet.first)

    @order = Order.find(@order.id)
    ActionMailer::Base.deliveries.clear
    @order.transaction_authorized

    @order = Order.find(@order.id)
    assert @order.authorized?
    assert @order.shipping_pending?
    assert_equal 2, ActionMailer::Base.deliveries.count
  end

   test "#transaction_captured" do
    @order = create(:authorized_order)
    @order.transaction_captured
    assert Order.find(@order.id).paid?
   end

  test "#transaction_purchased" do
    @order = create(:order_with_transaction)
    ActionMailer::Base.deliveries.clear
    @order.transaction_purchased

    @order = Order.find(@order.id)
    assert @order.paid?
    assert @order.shipping_pending?
    assert_equal @order.updated_at.to_s(:long), @order.splitable_paid_at
    assert_equal 2, ActionMailer::Base.deliveries.count
  end

  test "#transaction_cancelled" do
    @order = create(:authorized_order)
    @order.transaction_cancelled
    assert Order.find(@order.id).cancelled?
  end

  test "#transaction_refunded" do
    @order = create(:captured_order)
    @order.transaction_refunded
    assert Order.find(@order.id).refunded?
  end

end
