require 'spec_helper'

describe Navigation do
  describe "validations" do
    subject { create(:navigation) }
    it {
      must validate_presence_of(:product_group)
      must validate_presence_of(:link_group)
    }
  end
end
