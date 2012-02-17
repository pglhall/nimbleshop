module AdminHelper

  def admin_sidebar(label, path, identifier)
    case identifier
    when 'admin_products_path'
      hash = (params[:controller] == 'admin/products') ? {'class' => 'active'} : {}
      content_tag(:li, link_to(label, path), hash)

    when 'admin_custom_fields_path'
      hash = (params[:controller] == 'admin/custom_fields') ? {'class' => 'active'} : {}
      content_tag(:li, link_to(label, path), hash)

    when 'admin_product_groups_path'
      hash = (params[:controller] == 'admin/product_groups') ? {'class' => 'active'} : {}
      content_tag(:li, link_to(label, path), hash)

    when 'admin_link_groups_path'
      hash = (params[:controller] == 'admin/link_groups') ? {'class' => 'active'} : {}
      content_tag(:li, link_to(label, path), hash)

    when 'admin_shipping_zones_path'
      actions = ["admin/shipping_zones", "admin/shipping_methods"]
      hash = actions.include?(params[:controller]) ? {'class' => 'active'} : {}
      content_tag(:li, link_to(label, path), hash)

    when 'admin_payment_methods_path'
      hash = (params[:controller] == 'admin/payment_methods') ? {'class' => 'active'} : {}
      content_tag(:li, link_to(label, path), hash)

    when 'edit_admin_shop_path'
      hash = (params[:controller] == 'admin/shops') ? {'class' => 'active'} : {}
      content_tag(:li, link_to(label, path), hash)

    when 'admin_orders_path'
      hash = (params[:controller] == 'admin/orders') ? {'class' => 'active'} : {}
      content_tag(:li, link_to(label, path), hash)
    end

  end

  def display_payment_status(order)
    css_klass = order.payment_status == 'paid' ? 'label-success' : 'label-important'
    %Q{<span class="label #{css_klass}"> #{order.payment_status} </span>}.html_safe
  end

  def display_shipping_status(order)
    css_klass = case order.shipping_status
    when 'shipped'
      'label-success'
    when 'nothing_to_ship'
      'label-info'
    end
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
    return if email.blank?
    options = {:alt => 'avatar', :class => 'avatar', :size => 50}.merge! options
    id = Digest::MD5::hexdigest(email.strip.downcase)
    url = 'http://www.gravatar.com/avatar/' + id + '.jpg?d=mm&s=' + options[:size].to_s
    options.delete :size
    image_tag url, options
  end

end
