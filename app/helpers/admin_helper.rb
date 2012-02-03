module AdminHelper

  def display_payment_status(order)
    css_klass = order.payment_status == 'paid' ? 'success' : 'important'
    %Q{<span class="label #{css_klass}"> #{order.payment_status} </span>}.html_safe
  end

  def display_shipping_status(order)
    css_klass = %w(shipped nothing_to_ship).include?(order.shipping_status) ? 'success' : 'important'
    %Q{<span class="label #{css_klass}"> #{order.shipping_status} </span>}.html_safe
  end

  def creditcard_logo_for(creditcard)
    image_tag "#{creditcard.cardtype}.png"
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

  def gravatar_for(email, options = {})
      options = {:alt => 'avatar', :class => 'avatar', :size => 50}.merge! options
      id = Digest::MD5::hexdigest(email.strip.downcase)
      url = 'http://www.gravatar.com/avatar/' + id + '.jpg?d=mm&s=' + options[:size].to_s
      options.delete :size
      image_tag url, options
  end

end
