class ShippingMethod
  class RegionalShippingMethod < BaseShippingMethod
    delegate :upper_price_limit, to: :parent
    delegate :lower_price_limit, to: :parent

    def shipping_price
      @instance.parent.base_price + @instance.offset
    end
  end
end
