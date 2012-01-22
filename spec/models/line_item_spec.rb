require 'spec_helper'

describe LineItem do
  describe 'variant present' do
    let(:product) { create(:product, variants_enabled: true, price: 11) }
    let(:order) { create(:order) }
    let(:variant) { create(:variant, product: product, price: 27) }
    before do
      order.add(product, variant)
      @line_item = order.line_items.first
    end
    it 'should have the price of variant' do
      order.price.must_equal 27
      @line_item.price.must_equal 27
      @line_item.product_name.must_equal product.name
      @line_item.product_description.must_equal product.description
      @line_item.variant_info.must_equal "v1, v2, and v3"
    end
  end
end
