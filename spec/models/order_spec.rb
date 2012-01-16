require 'spec_helper'

describe Order do
  describe 'line_item should copy product attributes' do
    let(:order) { create(:order) }
    before do
      product = create(:product, name: 'n1', description: 'desc1', price: 10)
      order.add(product)
      product.update_attributes!(name: 'n2', description: 'desc2', price: 11)
    end
    it '' do
      line_item = order.line_items.first
      line_item.price.must_equal 10
      line_item.name.must_equal 'n1'
      line_item.description.must_equal 'desc1'
    end
  end

  describe '#available_shipping_methods' do
    let(:order1)  { create(:order)  }
    let(:order2)  { create(:order)  }
    let(:shipping_method1)  { create(:shipping_method, name: 'ground shipping1',
                                                      shipping_price: 100,
                                                      lower_price_limit: 1,
                                                      upper_price_limit: 199)  }
    let(:shipping_method2)  { create(:shipping_method, name: 'air shipping',
                                                      shipping_price: 120,
                                                      lower_price_limit: 70,
                                                      upper_price_limit: 199)  }
    before do
      order1.line_items << create(:line_item, quantity: 1)
      order2.line_items << create(:line_item, quantity: 2)
      shipping_method1
      shipping_method2
    end
    it '' do
      order1.amount.must_equal 50
      order2.amount.must_equal 100
      order1.available_shipping_methods.map(&:id).must_equal [ shipping_method1.id]
      order2.available_shipping_methods.map(&:id).must_equal [ shipping_method1.id, shipping_method2.id]
    end
  end

end
