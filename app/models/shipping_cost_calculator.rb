class ShippingCostCalculator
  def initialize(order)
    @order = order 
  end

  def shipping_cost
    @order.shipping_method.try(:shipping_cost) || 0
  end
end
