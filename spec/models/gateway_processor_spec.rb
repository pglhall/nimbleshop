require 'spec_helper'

describe GatewayProcessor do

  describe 'payment stuff' do
    before do
      shop = Factory(:shop)
      @creditcard = Factory.build(:creditcard)
      @order = Factory(:order)
      create_authorizenet_payment_method
      @payment_method_permalink = PaymentMethod.find_by_permalink!('authorize-net').permalink
    end

    describe '#authorize' do
      it '' do
      GatewayProcessor.new(payment_method_permalink: @payment_method_permalink,
                           order: @order,
                           amount: 1234,
                           creditcard: @creditcard).authorize

        tran = CreditcardTransaction.first
        CreditcardTransaction.count.must_equal 1
        tran.status.must_equal 'authorized'
        tran.active.must_equal true
        tran.transaction_gid.must_equal '1234567890'
      end
    end

    describe '#purchase' do
      it '' do
      GatewayProcessor.new(payment_method_permalink: @payment_method_permalink,
                           order: @order,
                           amount: 1234,
                           creditcard: @creditcard).purchase

        tran = CreditcardTransaction.first
        CreditcardTransaction.count.must_equal 1
        tran.status.must_equal 'purchased'
        tran.active.must_equal true
        tran.transaction_gid.must_equal '1234567892'
      end
    end

    describe '#capture' do
      it '' do
        GatewayProcessor.new(payment_method_permalink: @payment_method_permalink,
                             order: @order,
                             amount: 1234,
                             creditcard: @creditcard).authorize
        transaction = CreditcardTransaction.last
        transaction.capture(payment_method_permalink: @payment_method_permalink)

        tran = CreditcardTransaction.last
        CreditcardTransaction.count.must_equal 2
        tran.status.must_equal 'captured'
        tran.active.must_equal true
        tran.transaction_gid.must_equal '1234567891'
      end
    end

  end

end
