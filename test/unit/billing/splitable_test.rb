require 'test_helper'

module Billing
  class SpllitableCreateTest < ActiveRecord::TestCase
    setup do
      @product = create(:product, price: 10)
      @order   = create(:order)
      @request = stub(protocol: 'https', host_with_port: 'localhost:3000' )
    end

    test "when successful" do
      @order.add(@product)
      processor = NimbleshopSplitable::Billing.new(order: @order)

      expected  = "https://nimbleshop.splitable-draft.com/cws/0a0722b80ce3b662039884060ca49aaa7a1bb4135ea92fa47dc8"

      playcasette('splitable/split-draft-create-success') do
        error, split_url = processor.create_split(request: @request)
        assert_nil   error, "must be have no errors"
        assert_equal expected, split_url
      end
    end

    test "when failed" do
      processor = NimbleshopSplitable::Billing.new(order: @order)

      playcasette('splitable/split-draft-create-failure') do
        error, split_url = processor.create_split(request: @request)
        assert_nil   split_url, "must not create split url"
        assert_equal "Order must have atleast one line item", error
      end
    end
  end

  class SpllitablePaidTest < ActiveRecord::TestCase
    def callback_params(order)
      {
        invoice:  order.number,
        payment_status: "paid",
        api_secret: "82746e2d66cb8993",
        transaction_id: "852973493383974"
      }
    end

    setup do
      @product = create(:product, price: 10)
      @order   = create(:order)
    end

    test "when transaction is paid" do
      options = callback_params(@order)
      handler = NimbleshopSplitable::Billing.new(invoice: options[:invoice])


      handler.acknowledge(options)
      transaction = @order.payment_transactions.last

      assert_equal 'purchased',       transaction.operation
      assert_equal '852973493383974', transaction.transaction_gid
    end
  end

  class SpllitableVoidTest < ActiveRecord::TestCase
    def callback_params(order)
      {
        invoice:  order.number,
        payment_status: "cancelled",
        api_secret: "82746e2d66cb8993",
        transaction_id: "852973493383974"
      }
    end

    setup do
      @order   = create(:order)
    end

    test "when transaction is cancelled" do
      options = callback_params(@order)
      handler = NimbleshopSplitable::Billing.new(invoice: options[:invoice])

      assert handler.acknowledge(options)
      transaction = @order.payment_transactions.last

      assert_equal 'voided',          transaction.operation
      assert_equal '852973493383974', transaction.transaction_gid
    end

    test "when unknown order is used" do
      options = callback_params(@order)
      handler = NimbleshopSplitable::Billing.new(invoice: '123')

      assert_equal false, handler.acknowledge(options)
      assert_equal ["Unknown invoice number"], handler.errors
    end

    test "when payment_status is blank" do
      options = callback_params(@order).merge(payment_status: nil)
      handler = NimbleshopSplitable::Billing.new(invoice: options[:invoice])

      assert_equal false, handler.acknowledge(options)
      assert_equal ["Parameter payment_status is blank"], handler.errors
    end
  end
end


