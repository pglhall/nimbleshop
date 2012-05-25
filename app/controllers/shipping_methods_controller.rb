class ShippingMethodsController < ApplicationController

  theme :theme_resolver

  before_filter :verify_current_order

  def new
    @shipping_methods = Array.wrap(current_order.available_shipping_methods)
  end

  def update
    if params[:order].present? && params[:order].keys.include?('shipping_method_id')
      current_order.update_attributes(shipping_method_id: params[:order][:shipping_method_id])
      redirect_to  new_payment_processor_path
    else
      current_order.errors.add(:base, 'Please select a shipping method')
      render 'edit_shipping_method'
    end
  end

  def verify_current_order
    unless current_order
      redirect_to root_path
    end
  end

end
