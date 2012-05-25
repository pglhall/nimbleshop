module NootstrapHelper

  def body_id
    "#{params[:controller]}-#{params[:action]}".parameterize
  end

  def display_variant_info(line_item)
    return if line_item.variant_info.blank?
    "[#{line_item.variant_info}]"
  end

  def display_address(address)
    address.full_address_array.map { |i| html_escape(i) }.join('<br />').html_safe
  end

end
