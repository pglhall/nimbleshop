require 'test_helper'

class PaypalPaymentNotificationTest < ActiveRecord::TestCase

  def sample_params
    "mc_gross=11.23&invoice=3&protection_eligibility=Ineligible&item_number1=&payer_id=UU9QTKRET6CCA&tax=0.23&payment_date=13%3A46%3A50+Apr+01%2C+2012+PDT&payment_status=Completed&charset=windows-1252&mc_shipping=0.00&mc_handling=0.00&first_name=venkata&mc_fee=0.63&notify_version=3.4&custom=&payer_status=verified&business=pvdsub_1332777111_biz%40hotmail.com&num_cart_items=1&mc_handling1=0.00&verify_sign=A97HaEBl1Z9n6y3FnK2ES7ntmCFAA42qVBV1tGxSqeM5XnO3fijruk.r&payer_email=pvdsub_1332813592_per%40hotmail.com&mc_shipping1=0.00&tax1=0.00&txn_id=48D08257JB6543456&payment_type=instant&last_name=pasupuleti&item_name1=Handmade+vibrant+bangles&receiver_email=pvdsub_1332777111_biz%40hotmail.com&payment_fee=0.63&quantity1=1&receiver_id=DT54LCN8WQM8S&txn_type=cart&mc_gross_1=11.00&mc_currency=USD&residence_country=US&test_ipn=1&transaction_subject=Shopping+CartHandmade+vibrant+bangles&payment_gross=11.23&ipn_track_id=b1f9dd1a56ae8"
  end

  def setup
    @notification = PaypalPaymentNotification.new(raw_post: sample_params)
  end

  test "should know order total" do
    assert_equal 11.23, @notification.amount
  end

  test "should know transaction id" do
    assert_equal "48D08257JB6543456", @notification.transaction_id
  end

  test "should know invoice id" do
    assert_equal "3", @notification.invoice
  end

  test "should know status" do
    assert_equal 'Completed', @notification.status
  end

  test "should set the order_id" do
    @notification.save
    assert_equal "3", @notification.order_id
  end
end

class PaypalPaymentNotificationWithOrderTest < ActiveRecord::TestCase

  def sample_params(order)
    "mc_gross=#{order.total_amount}&invoice=#{order.number}&protection_eligibility=Ineligible&item_number1=&payer_id=UU9QTKRET6CCA&tax=#{order.tax.to_f.round(2)}&payment_date=19%3A37%3A16+Apr+03%2C+2012+PDT&payment_status=Completed&charset=windows-1252&mc_shipping=0.00&mc_handling=#{order.shipping_cost}&first_name=venkata&mc_fee=1.15&notify_version=3.4&custom=&payer_status=verified&business=pvdsub_1332777111_biz%40hotmail.com&num_cart_items=1&mc_handling1=0.00&verify_sign=AT2WTMewVr2cGzaANd7TRCes2yIEAgIJGpFFg7lq8gWKh4WA6sRvto21&payer_email=pvdsub_1332813592_per%40hotmail.com&mc_shipping1=0.00&tax1=0.00&txn_id=1FU42478V6164314U&payment_type=instant&last_name=pasupuleti&item_name1=Handmade+vibrant+bangles&receiver_email=pvdsub_1332777111_biz%40hotmail.com&payment_fee=1.15&quantity1=1&receiver_id=DT54LCN8WQM8S&txn_type=cart&mc_gross_1=#{order.line_items.first.product_price}&mc_currency=USD&residence_country=US&test_ipn=1&transaction_subject=Shopping+CartHandmade+vibrant+bangles&payment_gross=29.23&ipn_track_id=f00e3ee184c9d"
  end

  def setup
    @order = create(:order)
    @shipping_method = create(:country_shipping_method, base_price: 100, lower_price_limit: 1, upper_price_limit: 999)
    @order.shipping_address = create(:shipping_address)
    @product = create(:product, name: 'n1', description: 'desc1', price: 10)
    @order.add(@product)
    @notification = PaypalPaymentNotification.new(raw_post: sample_params(@order))
  end

  test "create order transactions for valid transactions" do
    assert @notification.valid_transaction?
    @notification.complete

    @order.reload

    transaction = @order.paypal_transactions.first
    assert_equal transaction.amount.to_f.round(2), @order.total_amount.to_f.round(2)
    assert_equal transaction.txn_id, @notification.transaction_id

    payment_method = @order.payment_method
    assert_equal "paypal-website-payments-standard", payment_method.permalink
    assert @order.paid?
  end
end
