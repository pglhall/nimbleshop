require 'spec_helper'

describe CreditcardTransaction do

  describe "#scopes" do
    before do
      @tx1 = create(:creditcard_transaction, status: 'authorized',  active: false) 
      @tx2 = create(:creditcard_transaction, status: 'captured',    active: true) 
      @tx3 = create(:creditcard_transaction, status: 'purchased',   active: true) 
      @tx4 = create(:creditcard_transaction, status: 'purchased',   active: false) 
      @tx5 = create(:creditcard_transaction, status: 'captured',    active: false) 
    end
    it {
      CreditcardTransaction.active.must_have_same_elements      [@tx2, @tx3]
      CreditcardTransaction.inactive.must_have_same_elements    [@tx1, @tx4, @tx5]
      CreditcardTransaction.authorized.must_have_same_elements  [ @tx1 ]
      CreditcardTransaction.captured.must_have_same_elements    [@tx2, @tx5]
      CreditcardTransaction.purchased.must_have_same_elements   [@tx3, @tx4]
    }
  end

  describe "#query_methods" do
    before do
      @tx1 = create(:creditcard_transaction, status: 'authorized',  active: false) 
      @tx2 = create(:creditcard_transaction, status: 'captured',    active: true) 
      @tx3 = create(:creditcard_transaction, status: 'purchased',   active: true) 
      @tx4 = create(:creditcard_transaction, status: 'purchased',   active: false) 
    end
    it {
      @tx1.must_be(:authorized?)
      @tx2.must_be(:captured?)
      @tx3.must_be(:purchased?)
      @tx4.must_be(:purchased?)
    }
  end
end
