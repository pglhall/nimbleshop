require 'spec_helper'

describe ShippingCostCalculator do

  describe "#shipping_cost" do
    it "shipping method is nil" do
      order     = Order.new
      calculator= ShippingCostCalculator.new(order)

      calculator.shipping_cost.must_equal 0
    end

    it "shipping method is not nil" do
      shipping  = mock(:shipping_cost => 3.99)
      order     = mock(shipping_method: shipping)
      calculator= ShippingCostCalculator.new(order)

      calculator.shipping_cost.must_equal 3.99
    end
  end
end
