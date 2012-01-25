require 'spec_helper'

describe Order do
  describe '#available_shipping_methods' do
    let(:order1)  { create(:order)  }
    let(:order2)  { create(:order)  }
    let(:shipping_method1)  { create(:country_shipping_method,
                                                      base_price: 100,
                                                      lower_price_limit: 1,
                                                      upper_price_limit: 199)  }
    let(:shipping_method2)  { create(:country_shipping_method,
                                                      base_price: 120,
                                                      lower_price_limit: 70,
                                                      upper_price_limit: 199)  }
    before do
      order1.line_items << create(:line_item, quantity: 1)
      order2.line_items << create(:line_item, quantity: 2)
      shipping_method1
      shipping_method2
    end
    it 'should have right values' do
      order1.amount.must_equal 50
      order2.amount.must_equal 100
      skip "this needs to take into accout where order is being shipped" do
        order1.available_shipping_methods.map(&:id).must_equal [ shipping_method1.id]
        order2.available_shipping_methods.map(&:id).must_equal [ shipping_method1.id, shipping_method2.id]
      end
    end
  end

end
