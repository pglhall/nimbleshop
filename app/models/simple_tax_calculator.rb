class SimpleTaxCalculator

  def initialize(order)
    @order = order
  end

  def tax
    (@order.price * tax_percentage * BigDecimal.new("0.01")).to_f.round(2)
  end

  private
    def tax_percentage
      Shop.first.tax_percentage
    end
end
