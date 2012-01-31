require 'spec_helper'

describe Order do
  describe '#available_shipping_methods' do
    let(:order)  { create(:order)  }
    let(:shipping_method)  { create(:country_shipping_method,
                                                      base_price: 100,
                                                      lower_price_limit: 1,
                                                      upper_price_limit: 199)  }
    before do
      order.shipping_address = create(:shipping_address, state: 'Florida', country: 'USA')
      shipping_method
    end
    it 'should have right values' do
      skip 'subba will look into it' do
        order.available_shipping_methods.size.must_equal 1
      end
    end
  end

end
