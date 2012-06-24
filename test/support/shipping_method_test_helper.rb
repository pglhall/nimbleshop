module ShippingMethodSpecHelper
  def create_regional_shipping_method
    create(:country_shipping_method, name: 'Ground Shipping', base_price: 3.99, minimum_order_amount: 1, maximum_order_amount: 99999).regions[0]
  end
end
