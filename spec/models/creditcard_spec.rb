require 'spec_helper'

describe Creditcard do

  describe "#validations" do
    subject { build(:creditcard) }

    it {
      must validate_presence_of(:number)
      must validate_presence_of(:first_name)
      must validate_presence_of(:last_name)
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
