module NimbleshopSimply
class Checkout::ShippingAddressesController < ApplicationController

  before_filter :verify_current_order

  def new
    current_order.initialize_addresses
    @countries = current_order.shippable_countries
    if @countries.blank?
      render text: "Shipping options are not configured for this order. Please contact shop administrator"
    end
  end

  def update
    if params[:order][:shipping_address_attributes][:use_for_billing] == '1'
      current_order.billing_address_same_as_shipping = true
    else
      current_order.billing_address_same_as_shipping = false
    end

    if current_order.update_attributes(params[:order].merge(validate_email: true))
      redirect_to new_checkout_shipping_method_path
    else
      @countries = ShippingMethod.available_for_countries(current_order.line_items_total)
      current_order.initialize_addresses
      render action: :new
    end
  end

end
end
