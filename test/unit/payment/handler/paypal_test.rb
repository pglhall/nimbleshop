require 'test_helper'

module Payment
  module Handler
    class PaypalAuthorizeTest < ActiveRecord::TestCase
      def raw1
        "mc_gross=152.73&invoice=54145619&protection_eligibility=Ineligible&item_number1=&payer_id=Q96HQCW3NMN8A&tax=1.73&payment_date=19%3A48%3A59+Apr+22%2C+2012+PDT&payment_status=Completed&charset=windows-1252&mc_shipping=0.00&mc_handling=10.00&first_name=buyer&mc_fee=4.73&notify_version=3.4&custom=&payer_status=verified&business=seller_1323037155_biz%40bigbinary.com&num_cart_items=1&mc_handling1=0.00&verify_sign=AAmQuqWvZCTtQW5vSunjl6MYb9xfACAPVvn0EpIPnon.Cyn5sYgI-bZB&payer_email=nimble_1333550340_per%40hotmail.com&mc_shipping1=0.00&tax1=0.00&txn_id=2LY704674J0179216&payment_type=instant&last_name=again&item_name1=Colorful+shoes&receiver_email=seller_1323037155_biz%40bigbinary.com&payment_fee=4.73&quantity1=1&receiver_id=EULE94DW3YTH4&txn_type=cart&mc_gross_1=141.00&mc_currency=USD&residence_country=US&test_ipn=1&transaction_subject=Shopping+CartColorful+shoes&payment_gross=152.73&ipn_track_id=72a7efbc940b7"
      end

      def raw_post(order_id, total)
        "mc_gross=#{total}&invoice=#{order_id}&protection_eligibility=Ineligible&item_number1=&payer_id=UU9QTKRET6CCA&tax=0.23&payment_date=13%3A46%3A50+Apr+01%2C+2012+PDT&payment_status=Completed&charset=windows-1252&mc_shipping=0.00&mc_handling=0.00&first_name=venkata&mc_fee=0.63&notify_version=3.4&custom=&payer_status=verified&business=pvdsub_1332777111_biz%40hotmail.com&num_cart_items=1&mc_handling1=0.00&verify_sign=A97HaEBl1Z9n6y3FnK2ES7ntmCFAA42qVBV1tGxSqeM5XnO3fijruk.r&payer_email=pvdsub_1332813592_per%40hotmail.com&mc_shipping1=0.00&tax1=0.00&txn_id=48D08257JB6543456&payment_type=instant&last_name=pasupuleti&item_name1=Handmade+vibrant+bangles&receiver_email=pvdsub_1332777111_biz%40hotmail.com&payment_fee=0.63&quantity1=1&receiver_id=DT54LCN8WQM8S&txn_type=cart&mc_gross_1=11.00&mc_currency=USD&residence_country=US&test_ipn=1&transaction_subject=Shopping+CartHandmade+vibrant+bangles&payment_gross=11.23&ipn_track_id=b1f9dd1a56ae8"
      end

      setup do
        @order = create(:order)
      end

      test "when authorize success" do
        processor = Paypal.new(raw_post: raw_post(@order.id, @order.total_amount))
        playcasette('paypal/authorize-success') do
          assert_equal processor.authorize, true
        end

        @order.reload

        transaction = @order.payment_transactions.last
        assert_equal transaction.operation, 'authorized'
        assert_equal transaction.success, true
        assert_equal true, @order.authorized?
        assert_equal "April 01, 2012 at 08:46 pm", @order.paid_at.to_s(:long)
        assert_equal Shop.paypal_website_payments_standard, @order.payment_method
        assert_equal transaction.amount, @order.total_amount_in_cents
      end

      test "when authorize fails with invalid credit card number" do
        processor = Paypal.new(raw_post: raw_post(@order.id, 10.48))
        assert_equal processor.authorize, false
        assert_nil @order.payment_method
      end
    end
=begin
  class PaypalCaptureTest < ActiveRecord::TestCase
    setup do
      @order = create(:order)
      @order.stubs(:total_amount).returns(100.48)
      @processor = Paypal.new(@order)
      creditcard = build(:creditcard)
      playcasette('authorize.net/authorize-success') do
        @processor.authorize(creditcard: creditcard)
      end

      @tsx_id = @order.payment_transactions.last.transaction_gid
    end

    test "when capture success" do
      creditcard = build(:creditcard)

      playcasette('authorize.net/capture-success') do
        assert_equal true, @processor.capture(transaction_id: @tsx_id)
      end

      transaction = @order.payment_transactions.last
      assert_equal transaction.operation, 'capture'
      assert_equal transaction.success, true
    end

    test "when capture fails" do
      creditcard = build(:creditcard, number: 2)

      playcasette('authorize.net/capture-failure') do
        assert_equal false, @processor.capture(transaction_id: @tsx_id)
      end

      transaction = @order.payment_transactions.last

      assert_equal transaction.success, false
      assert_equal transaction.operation, 'capture'
    end
  end

  class PaypalVoidTest < ActiveRecord::TestCase
    setup do
      @order = create(:order)
      @order.stubs(:total_amount).returns(100.48)
      @processor = Paypal.new(@order)
      creditcard = build(:creditcard)
      playcasette('authorize.net/authorize-success') do
        @processor.authorize(creditcard: creditcard)
      end

      @tsx_id = @order.payment_transactions.last.transaction_gid
    end

    test "when capture success" do
      creditcard = build(:creditcard)

      playcasette('authorize.net/void-success') do
        assert_equal true, @processor.void(transaction_id: @tsx_id)
      end

      transaction = @order.payment_transactions.last
      assert_equal transaction.operation, 'void'
      assert_equal transaction.success, true
    end

    test "when capture fails" do
      creditcard = build(:creditcard, number: 2)

      playcasette('authorize.net/void-failure') do
        assert_equal false, @processor.void(transaction_id: @tsx_id)
      end

      transaction = @order.payment_transactions.last

      assert_equal transaction.success, false
      assert_equal transaction.operation, 'void'
    end
  end
  class PaypalPurchaseTest < ActiveRecord::TestCase
    setup do
      @order = create(:order)
      @order.stubs(:total_amount).returns(100.48)
      @processor = Paypal.new(@order)
    end

    test "when purchase success" do
      creditcard = build(:creditcard)

      playcasette('authorize.net/purchase-success') do
        assert_equal @processor.purchase(creditcard: creditcard), true
      end

      transaction = @order.payment_transactions.last
      assert_equal transaction.operation, 'purchase'
      assert_equal transaction.success, true
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
      assert_equal transaction.operation, 'purchase'
    end
  end
=end
  end
end
