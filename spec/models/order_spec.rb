require 'spec_helper'

describe Order do
  describe "status values" do
    describe 'default value' do
      let(:order)  { create(:order)  }
      it '' do
        order.status.must_equal 'added_to_cart'
      end
    end

    describe '' do
      let(:order)  { create(:order)  }
      before do
        order.update_attributes(email: 'a@example.com')
      end
      it '' do
        order.status.must_equal 'billing_info_provided'
      end
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
