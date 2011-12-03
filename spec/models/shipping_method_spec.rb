require 'spec_helper'

describe ShippingMethod do
  describe "#condition_in_english" do
    let(:shipping_method)  { create(:shipping_method, shipping_price: 100, lower_price_limit: 1, upper_price_limit: 99)  }
    it '' do
      #shipping_method.condition_in_english.must_equal '$1.00 - $99.00'
    end
  end
end
