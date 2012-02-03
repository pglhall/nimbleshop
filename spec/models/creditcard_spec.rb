require 'spec_helper'

describe Creditcard do

  describe "#save" do
    it {
      creditcard = build(:creditcard)
      creditcard.save(validate: false)
      Creditcard.count.must_equal 1
    }
  end
end
