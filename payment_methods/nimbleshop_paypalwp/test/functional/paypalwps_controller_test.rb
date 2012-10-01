require 'test_helper'

class PaypalwpsControllerTest < ActionController::TestCase

  setup do
    @controller = NimbleshopPaypalwp::PaypalwpsController.new
    NimbleshopPaypalwp::Paypalwp.create!(name: 'Paypalwp', merchant_email: 'seller_1323037155_biz@bigbinary.com', description: 'this is description')
    @order = create :order_paid_using_paypalwp
  end

  test "should accept notification request" do

   hash = { "mc_gross" => "2.99",
     "invoice"=> @order.number,
     "item_mpn1"=>"",
     "protection_eligibility"=>"Ineligible",
     "item_count_unit1"=>"0",
     "item_number1"=>"",
     "tax"=>"0.04",
     "payer_id"=>"8NMFURHRJBP94",
     "payment_date"=>"05:50:35 Sep 27, 2012 PDT",
     "item_tax_rate1"=>"0",
     "payment_status"=>"Completed",
     "charset"=>"windows-1252",
     "mc_shipping"=>"0.00",
     "item_tax_rate_double1"=>"0.00",
     "mc_handling"=>"10.00",
     "first_name"=>"Rashmi",
     "mc_fee"=>"0.68",
     "notify_version"=>"3.7",
     "custom"=>"4",
     "payer_status"=>"unverified",
     "business"=>"seller_1323037155_biz@bigbinary.com",
     "num_cart_items"=>"1",
     "mc_handling1"=>"0.00",
     "verify_sign"=>"A52WYOWQ5f6.ZWIwRWkmVwieCw2gAWuLNstA178r02lkMvIe5mnmEib8",
     "payer_email"=>"hello@bigbinary.com",
     "mc_shipping1"=>"0.00",
     "item_style_number1"=>"",
     "tax1"=>"0.00",
     "item_plu1"=>"",
     "txn_id"=>"90U719813N3473230",
     "payment_type"=>"instant",
     "last_name"=>"Singh",
     "item_name1"=>"Hard wood case for iphone",
     "receiver_email"=>"neeraj@bigbinary.com",
     "item_isbn1"=>"",
     "payment_fee"=>"0.68",
     "quantity1"=>"1",
     "receiver_id"=>"DS94AKELVSP6U",
     "txn_type"=>"cart",
     "item_model_number1"=>"",
     "mc_gross_1"=>"3.00",
     "mc_currency"=>"USD",
     "item_taxable1"=>"N",
     "residence_country"=>"US",
     "transaction_subject"=>"4",
     "payment_gross"=>"13.04",
     "ipn_track_id"=>"841618d367692"}

    post :notify, { use_route: :nimbleshop_paypalwp }.merge(hash)
    @order.reload
    assert @order.purchased?, "payment status is #{@order.payment_status}"
  end

end

