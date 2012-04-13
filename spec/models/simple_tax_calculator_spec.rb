require 'test_helper'

class SimpleTaxCalculatorTest < ActiveRecord::TestCase

  setup do
  end

  test "tax for the order" do
    order = create :order_with_line_items
    Shop.first.update_attribute(:tax_percentage, 10)

    assert_equal 50.00, order.reload.line_items_total
    assert_equal 5.0, SimpleTaxCalculator.new(order).tax
  end
end
