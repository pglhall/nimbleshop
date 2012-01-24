class ShippingMethod
  class RegionalShippingMethod < BaseShippingMethod
    def shipping_price
      @instance.parent.base_price + @instance.offset
    end
  end
end
