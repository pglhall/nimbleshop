require 'spec_helper'

describe SimpleTaxCalculator do
  describe "#tax" do
    it "must be tax_percentage * order_cost" do
      order = Order.new
      shop  = Shop.new(tax_percentage: 5)
      order.expects(:price).returns(300)
      calculator = SimpleTaxCalculator.new(order, shop)

      tax_amount = calculator.tax
      assert_kind_of BigDecimal, tax_amount

      calculator.tax.to_f.must_equal 15.0
    end
  end
end
