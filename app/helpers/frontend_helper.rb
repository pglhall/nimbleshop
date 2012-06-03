module FrontendHelper

  def body_id
    "#{params[:controller]}-#{params[:action]}".parameterize
  end

  def display_address(address)
    return if address.nil?
    address.full_address_array.map { |i| html_escape(i) }.join('<br />').html_safe
  end

end
