require 'spec_helper'

describe Variation do
  describe "all three variations active" do
    let(:product) { create(:product) }
    let(:variant) { create(:variant, product: product) }
    it 'should set the value to nil when variation is turned active as false' do
      variant.variation3_value.must_equal 'v3'
      product.variation3.update_attributes!(active: false)
      variant.reload
      variant.variation3_value.must_equal nil
    end
  end
end
