require 'spec_helper'

describe GatewayProcessor do

  describe 'payment stuff' do
    before do
      shop = Factory(:shop)
      @creditcard = Factory.build(:creditcard)
      @order = Factory(:order)
      @credit_card_handler = GatewayProcessor.new
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
        transaction.capture

        tran = Transaction.last
        Transaction.count.must_equal 2
        tran.status.must_equal 'captured'
        tran.active.must_equal true
        tran.transaction_gid.must_equal '1234567891'
      end
    end

  end

end


