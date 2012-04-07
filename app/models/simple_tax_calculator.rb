class SimpleTaxCalculator
  def initialize(order)
    @order = order
  end

  def tax
    @order.price * Shop.first.tax_percentage * 0.01
  end
end
