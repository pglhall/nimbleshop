class ShippingMethod
  class CountryShippingMethod < BaseShippingMethod
    def shipping_price
      @instance.base_price
    end
  end
end
