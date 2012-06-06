require 'test_helper'

class TaxCalculatorTest < ActiveRecord::TestCase
  test "shipping method is nil" do
    order     = Order.new
    calculator= ShippingCostCalculator.new(order)

    assert_equal 0, calculator.shipping_cost
  end

  test "shipping method is not nil" do
    shipping  = mock(:shipping_cost => 3.99)
    order     = mock(shipping_method: shipping)
    calculator= ShippingCostCalculator.new(order)

    assert_equal 3.99, calculator.shipping_cost
  end
end
