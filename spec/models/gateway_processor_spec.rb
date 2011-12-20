require 'spec_helper'

describe GatewayProcessor do

  describe 'payment stuff' do
    before do
      shop = Factory(:shop)
      @creditcard = Factory.build(:creditcard)
      @order = Factory(:order)
      create_authorizenet_payment_method
      @payment_method_permalink = PaymentMethod.find_by_permalink!('authorize-net').permalink
      @credit_card_handler = GatewayProcessor.new(payment_method_permalink: @payment_method_permalink)
    end

    describe '#authorize' do
      it '' do
        @credit_card_handler.authorize(1234, @creditcard, @order)
        tran = Transaction.first
        Transaction.count.must_equal 1
        tran.status.must_equal 'authorized'
        tran.active.must_equal true
        tran.transaction_gid.must_equal '1234567890'
      end
    end

    describe '#purchase' do
      it '' do
        @credit_card_handler.purchase(1234, @creditcard, @order)
        tran = Transaction.first
        Transaction.count.must_equal 1
        tran.status.must_equal 'purchased'
        tran.active.must_equal true
        tran.transaction_gid.must_equal '1234567892'
      end
    end

    describe '#capture' do
      it '' do
        @credit_card_handler.authorize(1234, @creditcard, @order)
        transaction = Transaction.last
        transaction.capture(payment_method_permalink: @payment_method_permalink)

        tran = Transaction.last
        Transaction.count.must_equal 2
        tran.status.must_equal 'captured'
        tran.active.must_equal true
        tran.transaction_gid.must_equal '1234567891'
      end
    end

  end

end
