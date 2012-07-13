class TaxCalculator
  def initialize(order)
    @order = order
  end

  # Returns tax amount in float
  def tax
    amount = BigDecimal(@order.line_items_total.to_s)

    (amount * BigDecimal(tax_percentage.to_s) * BigDecimal.new("0.01")).round(2).to_f
  end

  private

  def tax_percentage
    Shop.current.tax_percentage
  end
end
