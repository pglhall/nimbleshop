module AdminHelper

  def paypal_website_payments_standard_enabled?
    PaymentMethod.find_by_permalink('paypal-website-payments-standard').enabled
  end

  def authorize_net_enabled?
    PaymentMethod.find_by_permalink('authorize-net').enabled
  end


  def build_payment_method_tabs
    result = []

    options = params[:action] == 'index' ? {class: 'active'} : nil
    result << content_tag(:li, link_to('Payment methods', admin_payment_methods_path), options)

    @enabled_payment_methods.each do |payment_method|
      options = params[:id] == payment_method.id.to_s ? {'class' => 'active'} : nil
      result << content_tag(:li, link_to(payment_method.name, admin_payment_method_path(payment_method)), options)
    end
    result.join.html_safe
  end

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
