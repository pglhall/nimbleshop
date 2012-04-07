require 'test_helper'

class SimpleTaxCalculatorTest < ActiveRecord::TestCase

  setup do
    Shop.first.update_attribute(:tax_percentage, 5)
  end

  test "tax for the order" do
    order = mock(price: 300)

    assert_equal 15.0, SimpleTaxCalculator.new(order).tax
  end
end
