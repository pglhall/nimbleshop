module AdminHelper

  def shipping_method_condition_in_english(shipping_method)
    if shipping_method.upper_price_limit
      s = number_to_currency(shipping_method.lower_price_limit)
      s << " - "
      s << number_to_currency(shipping_method.upper_price_limit)
    else
      number_to_currency(shipping_method.lower_price_limit) + ' minimum'
    end
  end

end
