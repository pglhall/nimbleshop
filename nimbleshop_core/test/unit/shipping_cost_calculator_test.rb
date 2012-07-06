require 'test_helper'

class ShippingCostCalculatorTest < ActiveRecord::TestCase

  test "shipping method is nil" do
    order     = Order.new
    calculator= ShippingCostCalculator.new(order)

    assert_equal 0, calculator.shipping_cost
  end

  test "shipping method is not nil" do
    shipping_method  = build :country_shipping_method
    order     = build :order, shipping_method: shipping_method
    calculator= ShippingCostCalculator.new(order)

    assert_equal 2.99, calculator.shipping_cost.round(2).to_f
  end
end
