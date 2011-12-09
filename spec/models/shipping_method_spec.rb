require 'spec_helper'

describe ShippingMethod do
  describe "#available_for" do
    let(:shipping_method)  { create(:shipping_method, shipping_price: 100,
                                                      lower_price_limit: 1,
                                                      upper_price_limit: 99)  }
    let(:order)  { create(:order) }
    before do
      order.line_items << create(:line_item)
    end
    it '' do
      shipping_method.available_for(order).must_equal true
    end
  end
end
