require 'spec_helper'

describe LineItem do

  describe "#copy_attributes" do
    describe "without variant" do
      let(:order) { create(:order) }
      before do
        product = create(:product, name: 'n1', description: 'desc1', price: 10)
        order.add(product)
        product.update_attributes!(name: 'n2', description: 'desc2', price: 11)
      end
      it 'should have right values' do
        line_item = order.line_items.first
        line_item.price.must_equal 10
        line_item.name.must_equal 'n1'
        line_item.description.must_equal 'desc1'
      end
    end

    describe 'with variant' do
      let(:product) { create(:product, variants_enabled: true, price: 11) }
      let(:order) { create(:order) }
      before do
        product.variations.each { |variation| variation.update_attributes!(active: true) }
        variant = create(:variant, product: product, price: 27)
        order.add(product, variant)
        @line_item = order.line_items.first
      end
      it 'should have the price of variant' do
        order.line_items_total.must_equal 27
        @line_item.price.must_equal 27
        @line_item.product_name.must_equal product.name
        @line_item.product_description.must_equal product.description
        @line_item.variant_info.must_equal "v1, v2, and v3"
      end
    end
  end
end
