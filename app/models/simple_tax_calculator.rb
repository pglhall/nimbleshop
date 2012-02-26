class SimpleTaxCalculator
  def initialize(order, shop)
    @order = order 
    @shop  = shop
  end

  def tax
    @order.price * @shop.tax_percentage * 0.01
  end
end
