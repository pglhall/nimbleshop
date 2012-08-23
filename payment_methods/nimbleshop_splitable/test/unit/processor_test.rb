require 'test_helper'

module Processor
  class SpllitableCreateTest < ActiveRecord::TestCase
    setup do
      @product = create(:product, price: 10)
      @order   = create(:order)
      @request = stub(protocol: 'https', host_with_port: 'localhost:3000' )
    end

    test "when successful" do
      @order.add(@product)
      processor = NimbleshopSplitable::Processor.new(order: @order)

      expected  = "https://nimbleshop.splitable-draft.com/cws/0a0722b80ce3b662039884060ca49aaa7a1bb4135ea92fa47dc8"

      playcasette('splitable/split-draft-create-success') do
        error, split_url = processor.create_split(request: @request)
        assert_nil   error, "must be have no errors"
        assert_equal expected, split_url
        assert_equal NimbleshopSplitable::Splitable.first, @order.payment_method
        assert       @order.pending?
      end
    end

    test "when failed" do
      processor = NimbleshopSplitable::Processor.new(order: @order)

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
      processor = NimbleshopSplitable::Processor.new(order: @order)
      playcasette('splitable/split-draft-create-success') do
        processor.create_split(request: @request)
      end

      assert @order.pending?

      options = callback_params(@order)
      processor = NimbleshopSplitable::Processor.new(invoice: options[:invoice])

      processor.acknowledge(options)
      transaction = @order.payment_transactions.last

      assert_equal 'purchased',       transaction.operation
      assert_equal '852973493383974', transaction.transaction_gid
      @order.reload
      assert @order.purchased?
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
      processor = NimbleshopSplitable::Processor.new(order: @order)
      playcasette('splitable/split-draft-create-success') do
        processor.create_split(request: @request)
      end

      assert @order.pending?

      options = callback_params(@order)
      processor = NimbleshopSplitable::Processor.new(invoice: options[:invoice])
      assert processor.acknowledge(options)
      transaction = @order.payment_transactions.last

      assert_equal 'voided',          transaction.operation
      assert_equal '852973493383974', transaction.transaction_gid
      @order.reload
      assert @order.voided?
    end

    test "when an invalid order number is used" do
      options = callback_params(@order)
      processor = NimbleshopSplitable::Processor.new(invoice: '123')

      assert_equal false, processor.acknowledge(options)
      assert_equal ["Unknown invoice number"], processor.errors
    end

    test "when payment_status is blank" do
      options = callback_params(@order).merge(payment_status: nil)
      processor = NimbleshopSplitable::Processor.new(invoice: options[:invoice])

      assert_equal false, processor.acknowledge(options)
      assert_equal ["Parameter payment_status is blank"], processor.errors
    end
  end
end
