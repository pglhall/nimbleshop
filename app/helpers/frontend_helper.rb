module FrontendHelper

  def body_id
    "#{params[:controller]}-#{params[:action]}".parameterize
  end

  def display_address(address)
    return if address.nil?
    address.full_address_array.map { |i| html_escape(i) }.join('<br />').html_safe
  end

  def display_page_title
    if @page_title
      @page_title.html_safe +  "&mdash;".html_safe +  html_escape(@shop.name)
    else
      @shop.name
    end
  end

  # returns nil if the product does not have a main picture
  def product_main_picture(product, version = :medium_plus)
    if pic = product.picture
      image_tag(pic.picture_url(version), alt: product.name)
    end
  end

  def items_count_in_cart
    current_order.blank? ? 0 : current_order.item_count
  end

  def options_for_country(country_code)
    grouped_options_for_country_state_codes[country_code]
  end

  def options_for_countries(country_codes)
    country_codes.map {|t| [ Carmen::Country.coded(t).name, t ] }
  end

end
