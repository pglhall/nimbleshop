class OrdersController < ApplicationController

  before_filter :set_instance_variables_for_shipping_method, only: [:edit_shipping_method, :update_shipping_method]

  theme :theme_resolver

  def edit_shipping_method
    render
  end

  def update_shipping_method
    if params[:order].present? && params[:order].keys.include?('shipping_method_id')
      current_order.update_attributes(shipping_method_id: params[:order][:shipping_method_id])
      redirect_to  new_payment_processor_path
    else
      current_order.errors.add(:base, 'Please select a shipping method')
      render 'edit_shipping_method'
    end
  end

  def paid
    @page_title = 'Purchase is complete'
    @order = Order.find_by_number!(params[:id])
    @payment_method = PaymentMethod.find_by_permalink!('authorize-net')
  end

  def edit
    @page_title = 'Shipping information'
    current_order.initialize_addresses
    @countries = ShippingMethod.available_for_countries(current_order.amount)
  end

  def update
    if @current_order.update_attributes(params[:order].merge(validate_email: true))
      redirect_to edit_shipping_method_order_path(current_order)
    else
      @current_order.initialize_addresses
      render 'edit'
    end
  end

  private

  def set_instance_variables_for_shipping_method
    @page_title = 'Pick shipping method'
    @shipping_methods = Array.wrap(current_order.available_shipping_methods)
  end
end
