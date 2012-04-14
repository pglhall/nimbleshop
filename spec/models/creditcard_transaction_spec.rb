require 'test_helper'

class CreditTransactionTest < ActiveSupport::TestCase

  setup do
    @tx1 = create(:creditcard_transaction, status: 'authorized',  active: false) 
    @tx2 = create(:creditcard_transaction, status: 'captured',    active: true) 
    @tx3 = create(:creditcard_transaction, status: 'purchased',   active: true) 
    @tx4 = create(:creditcard_transaction, status: 'purchased',   active: false) 
    @tx5 = create(:creditcard_transaction, status: 'captured',    active: false) 
  end

  test "scoped" do
    assert_must_have_same_elements CreditcardTransaction.active,      [@tx2, @tx3]
    assert_must_have_same_elements CreditcardTransaction.inactive,    [@tx1, @tx4, @tx5]
    assert_must_have_same_elements CreditcardTransaction.authorized,  [ @tx1 ]
    assert_must_have_same_elements CreditcardTransaction.captured,    [@tx2, @tx5]
    assert_must_have_same_elements CreditcardTransaction.captured,    [@tx2, @tx5]
    assert_must_have_same_elements CreditcardTransaction.purchased,   [@tx3, @tx4]
  end

  test '#query_methods' do
    assert create(:creditcard_transaction, status: 'authorized',  active: false).authorized?
    assert create(:creditcard_transaction, status: 'captured',    active: true).captured?
    assert create(:creditcard_transaction, status: 'purchased',   active: true).purchased?
    assert create(:creditcard_transaction, status: 'purchased',   active: false).purchased?
  end

end

