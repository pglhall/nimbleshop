require 'test_helper'

class TaxCalculatorTest < ActiveRecord::TestCase

  test "tax for the order" do
    order = create :order_with_line_items
    Shop.current.update_column(:tax_percentage, 10)

    assert_equal 50.00, order.reload.line_items_total
    assert_equal 5.0, TaxCalculator.new(order).tax
  end

end
