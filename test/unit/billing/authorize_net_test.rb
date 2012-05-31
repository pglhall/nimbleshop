require 'test_helper'

module Billing
  class NimbleshopAuthorizeNetAuthorizeTest < ActiveRecord::TestCase
    setup do
      @order = create(:order)
      @order.stubs(:total_amount).returns(100.48)
      @processor = NimbleshopAuthorizedotnet::Billing.new(@order)
    end

    test "when authorize success" do
      creditcard = build(:creditcard)

      playcasette('authorize.net/authorize-success') do
        assert_equal true, @processor.authorize(creditcard: creditcard)
      end

      @order.reload

      transaction = @order.payment_transactions.last
      assert_equal 'authorized', transaction.operation
      assert_equal true, transaction.success
      assert_equal NimbleshopAuthorizedotnet::Authorizedotnet.first, @order.payment_method
      assert       @order.authorized?
    end

    test "authorization fails when credit card number is not entered" do
      creditcard = build(:creditcard, number: nil)
      assert_equal false, @processor.authorize(creditcard: creditcard)

      @order.reload

      assert_nil    @order.payment_method
      assert        @order.abandoned?
    end

    test "authorization fails with invalid credit card number" do
      creditcard = build(:creditcard, number: 2)

      playcasette('authorize.net/authorize-failure') do
        assert_equal false, @processor.authorize(creditcard: creditcard)
      end

      @order.reload

      assert_nil    @order.payment_method
      assert        @order.abandoned?
    end
  end

  class AuthorizeNetCaptureTest < ActiveRecord::TestCase
    setup do
      @order     = create(:order, payment_method: NimbleshopAuthorizedotnet::Authorizedotnet.first)
      @order.stubs(:total_amount).returns(100.48)
      @processor = NimbleshopAuthorizedotnet::Billing.new(@order)
      creditcard = build(:creditcard)

      playcasette('authorize.net/authorize-success') do
        @processor.authorize(creditcard: creditcard)
      end

      @tsx_id = @order.payment_transactions.last.transaction_gid
    end

    test "when capture success" do
      creditcard = build(:creditcard)

      playcasette('authorize.net/capture-success') do
        assert_equal true, @processor.capture(transaction_gid: @tsx_id)
      end

      @order.reload
      transaction = @order.payment_transactions.last
      assert_equal  'captured', transaction.operation
      assert_equal  true, transaction.success
      assert        @order.paid?
    end

    test "when capture fails" do
      creditcard = build(:creditcard, number: 2)

      playcasette('authorize.net/capture-failure') do
        assert_equal false, @processor.capture(transaction_gid: @tsx_id)
      end

      @order.reload

      transaction = @order.payment_transactions.last

      assert_equal false, transaction.success
      assert_equal 'captured', transaction.operation
      assert       @order.authorized?
    end
  end

  class AuthorizeNetRefundTest < ActiveRecord::TestCase
    setup do
      @order = create(:order)
      @order.stubs(:total_amount).returns(100.48)
      @processor = NimbleshopAuthorizedotnet::Billing.new(@order)
      creditcard = build(:creditcard)

      playcasette('authorize.net/purchase-success') do
        assert_equal true, @processor.purchase(creditcard: creditcard)
      end

      assert @order.reload.paid?

      @transaction = @order.payment_transactions.last
    end

    test "when refund success" do

      playcasette('authorize.net/refund-success') do
        assert_equal true, @processor.refund(transaction_gid:   @transaction.transaction_gid,
                                             card_number:       @transaction.metadata[:card_number])
      end

      @order.reload
      transaction = @order.payment_transactions.last

      assert_equal  'refunded', transaction.operation
      assert_equal  true, transaction.success
      assert_equal  NimbleshopAuthorizedotnet::Authorizedotnet.first, @order.payment_method
      assert        @order.refunded?
    end

    test "when refund fails" do

      playcasette('authorize.net/refund-failure') do
        assert_equal false, @processor.refund(transaction_gid: @transaction.transaction_gid, card_number: '1234')
      end

      @order.reload

      transaction = @order.payment_transactions.last

      assert_equal 'refunded', transaction.operation
      assert_equal false, transaction.success
    end
  end

  class AuthorizeNetVoidTest < ActiveRecord::TestCase
    setup do
      @order = create(:order)
      @order.stubs(:total_amount).returns(100.48)
      @processor = NimbleshopAuthorizedotnet::Billing.new(@order)
      creditcard = build(:creditcard)

      playcasette('authorize.net/authorize-success') do
        assert_equal true, @processor.authorize(creditcard: creditcard)
      end

      @tsx_id = @order.payment_transactions.last.transaction_gid
    end

    test "when capture success" do
      playcasette('authorize.net/void-success') do
        assert_equal true, @processor.void(transaction_gid: @tsx_id)
      end

      @order.reload
      transaction = @order.payment_transactions.last

      assert_equal  'voided', transaction.operation
      assert_equal  true, transaction.success
      assert_equal  NimbleshopAuthorizedotnet::Authorizedotnet.first, @order.payment_method
      assert        @order.cancelled?
    end

    test "when capture fails" do
      playcasette('authorize.net/void-failure') do
        assert_equal false, @processor.void(transaction_gid: @tsx_id)
      end

      @order.reload

      transaction = @order.payment_transactions.last

      assert_equal 'voided', transaction.operation
      assert_equal false, transaction.success
    end
  end

  class AuthorizeNetPurchaseTest < ActiveRecord::TestCase
    setup do
      @order = create(:order)
      @order.stubs(:total_amount).returns(100.48)
      @processor = NimbleshopAuthorizedotnet::Billing.new(@order)
    end

    test "when purchase success" do
      creditcard = build(:creditcard)

      playcasette('authorize.net/purchase-success') do
        assert_equal true, @processor.purchase(creditcard: creditcard)
      end

      @order.reload

      transaction = @order.payment_transactions.last
      assert_equal  'purchased', transaction.operation
      assert_equal  true, transaction.success
      assert        @order.paid?
    end

    test "purchase fails when credit card number is not entered " do
      creditcard = build(:creditcard, number: nil)

      playcasette('authorize.net/purchase-failure') do
        assert_equal false, @processor.purchase(creditcard: creditcard)
      end

      assert       @order.abandoned?
    end

    test "purchase fails when invalid credit card number is entered" do
      creditcard = build(:creditcard, number: 2)

      playcasette('authorize.net/purchase-failure') do
        assert_equal false, @processor.purchase(creditcard: creditcard)
      end

      transaction = @order.payment_transactions.last

      assert_equal false, transaction.success
      assert_equal 'purchased', transaction.operation
      assert       @order.abandoned?
    end
  end
end
