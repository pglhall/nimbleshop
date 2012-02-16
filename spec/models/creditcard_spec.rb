require 'spec_helper'

describe Creditcard do

  describe "#save" do
    it {
      creditcard = build(:creditcard)
      creditcard.save(validate: false)
      Creditcard.count.must_equal 1
    }
  end

  describe "#build_for_payment_processing" do
    it {
      skip "undefined method `state' for #<ShippingAddress:0x007fad06dd5260>" do
        params = {number: '4007000000027'}
        order = create(:order)
        creditcard = Creditcard.build_for_payment_processing(params, order)
        assert creditcard.valid?
      end
    }
  end
end
