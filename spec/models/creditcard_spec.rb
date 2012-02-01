require 'spec_helper'

describe Creditcard do

  describe "#save" do
    let(:creditcard) { build(:creditcard) }

    it "should save" do
      creditcard.save(validate: false)
      Creditcard.count.must_equal 1
      end
  end
end
