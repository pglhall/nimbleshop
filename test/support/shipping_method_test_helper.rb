module ShippingMethodSpecHelper
  def create_regional_shipping_method
    create(:country_shipping_method, name: 'Ground Shipping', base_price: 3.99, lower_price_limit: 1, upper_price_limit: 99999).regions[0]
  end
end

def wait_for_ajax
  wait_until { page.evaluate_script("typeof(jQuery)!='undefined' && jQuery.active") == 0 }
end
