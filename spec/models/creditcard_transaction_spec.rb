require 'spec_helper'

describe CreditcardTransaction do

  describe "#save" do
    let(:creditcard_transaction) { build(:creditcard_transaction) }

    it "should save" do
      creditcard_transaction.save(validate: false)
      CreditcardTransaction.count.must_equal 1
      end
  end
end
