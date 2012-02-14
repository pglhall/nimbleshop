require 'spec_helper'

describe Order do

  describe '#available_shipping_methods' do
    it {
      order = create(:order)
      order.add(create(:product))
      shipping_method = create(:country_shipping_method, base_price: 100, lower_price_limit: 1, upper_price_limit: 99999)
      order.shipping_address = create(:shipping_address)
      order.available_shipping_methods.size.must_equal 1
    }
  end

  describe '#set_quantity' do
    it {
      order = create(:order)
      product = create(:product)
      order.add(product)
      order.set_quantity(product, 3)
    }
  end

end
