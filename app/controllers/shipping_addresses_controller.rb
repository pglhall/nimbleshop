class ShippingAddressesController < ApplicationController

  theme :theme_resolver

  before_filter :verify_current_order

  def new
    current_order.initialize_addresses
    @countries = current_order.shippable_countries
  end

  def update
    if current_order.update_attributes(params[:order].merge(validate_email: true))
      redirect_to new_order_shipping_method_path(current_order)
    else
      @countries = ShippingMethod.available_for_countries(current_order.line_items_total)
      current_order.initialize_addresses
      render action: :new
    end
  end

  def verify_current_order
    unless current_order
      redirect_to root_path
    end
  end

end
