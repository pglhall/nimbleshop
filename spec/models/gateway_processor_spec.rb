require 'spec_helper'

describe GatewayProcessor do

  let(:shop) { create(:shop) }
  let(:creditcard) { build(:creditcard) }
  let(:order) { create(:order) }
  create_authorizenet_payment_method
  let(:payment_method_permalink) { PaymentMethod.find_by_permalink!('authorize-net').permalink }

  describe '#authorize' do
    before do
      GatewayProcessor.new(payment_method_permalink: payment_method_permalink,
                           order: order,
                           amount: 1234,
                           creditcard: creditcard).authorize
      @tran = CreditcardTransaction.first
    end
    it 'should have right values' do
      @tran.status.must_equal 'authorized'
      @tran.active.must_equal true
      @tran.transaction_gid.must_equal '1234567890'
    end
  end

  describe '#purchase' do
    before do
      GatewayProcessor.new(payment_method_permalink: payment_method_permalink,
                           order: order,
                           amount: 1234,
                           creditcard: creditcard).purchase
      @tran = CreditcardTransaction.first
    end
    it 'should have right values' do
      CreditcardTransaction.count.must_equal 1
      @tran.status.must_equal 'purchased'
      @tran.active.must_equal true
      @tran.transaction_gid.must_equal '1234567892'
    end
  end

  describe '#capture' do
    before do
      GatewayProcessor.new(payment_method_permalink: payment_method_permalink,
                           order: order,
                           amount: 1234,
                           creditcard: creditcard).authorize
      transaction = CreditcardTransaction.last
      transaction.capture(payment_method_permalink: payment_method_permalink)
    end
    it 'should have right values' do
      CreditcardTransaction.count.must_equal 2
      transaction = CreditcardTransaction.last
      transaction.status.must_equal 'captured'
      transaction.active.must_equal true
      transaction.transaction_gid.must_equal '1234567891'
    end
  end

end
