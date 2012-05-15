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
        assert_equal @processor.authorize(creditcard: creditcard), true
      end

      @order.reload

      transaction = @order.payment_transactions.last
      assert_equal transaction.operation, 'authorized'
      assert_equal transaction.success, true
      assert_equal Shop.authorize_net, @order.payment_method
      assert       @order.authorized?
    end

    test "when authorize fails with invalid credit card number" do
      creditcard = build(:creditcard, number: nil)
      assert_equal @processor.authorize(creditcard: creditcard), false

      @order.reload

      assert_nil    @order.payment_transactions.last
      assert_nil    @order.payment_method
      assert        @order.abandoned?
    end

    test "when authorize fails with bogus credit card" do
      creditcard = build(:creditcard, number: 2)

      playcasette('authorize.net/authorize-failure') do
        assert_equal @processor.authorize(creditcard: creditcard), false
      end

      @order.reload

      transaction = @order.payment_transactions.last

      assert_equal  transaction.success, false
      assert_equal  transaction.operation, 'authorized'
      assert_nil    @order.payment_method
      assert        @order.abandoned?
    end
  end

  class AuthorizeNetCaptureTest < ActiveRecord::TestCase
    setup do
      @order     = create(:order, payment_method: Shop.authorize_net)
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
      assert_equal  transaction.operation, 'captured'
      assert_equal  transaction.success, true
      assert        @order.paid?
    end

    test "when capture fails" do
      creditcard = build(:creditcard, number: 2)

      playcasette('authorize.net/capture-failure') do
        assert_equal false, @processor.capture(transaction_gid: @tsx_id)
      end

      @order.reload

      transaction = @order.payment_transactions.last

      assert_equal transaction.success, false
      assert_equal transaction.operation, 'captured'
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
        assert_equal @processor.purchase(creditcard: creditcard), true
      end

      assert @order.reload.paid?

      @transaction = @order.payment_transactions.last
    end

    test "when refund success" do

      playcasette('authorize.net/refund-success') do
        assert_equal true, @processor.refund(transaction_gid:   @transaction.transaction_gid,
                                             card_number:       @transaction.additional_info[:card_number])
      end

      @order.reload
      transaction = @order.payment_transactions.last

      assert_equal  'refunded', transaction.operation
      assert_equal  true, transaction.success
      assert_equal  Shop.authorize_net, @order.payment_method
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
        assert_equal @processor.authorize(creditcard: creditcard), true
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
      assert_equal  Shop.authorize_net, @order.payment_method
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
        assert_equal @processor.purchase(creditcard: creditcard), true
      end

      @order.reload

      transaction = @order.payment_transactions.last
      assert_equal  transaction.operation, 'purchased'
      assert_equal  transaction.success, true
      assert        @order.paid?
    end

    test "when purchase fails with invalid credit card number" do
      creditcard = build(:creditcard, number: nil)
      assert_equal @processor.purchase(creditcard: creditcard), false

      transaction = @order.payment_transactions.last

      assert_nil transaction
    end

    test "when purchase fails with bogus credit card" do
      creditcard = build(:creditcard, number: 2)

      playcasette('authorize.net/purchase-failure') do
        assert_equal @processor.purchase(creditcard: creditcard), false
      end

      transaction = @order.payment_transactions.last

      assert_equal transaction.success, false
      assert_equal transaction.operation, 'purchased'
      assert       @order.abandoned?
    end
  end
end
