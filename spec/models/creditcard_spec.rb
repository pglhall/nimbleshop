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
end
