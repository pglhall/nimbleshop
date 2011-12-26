class OrdersController < ApplicationController

  before_filter :set_instance_variables_for_shipping_method, only: [:edit_shipping_method, :update_shipping_method]

  theme :theme_resolver

  def edit_shipping_method
    render
  end

  def update_shipping_method
    if params[:order].present? && params[:order].keys.include?('shipping_method_id')
      current_order.update_attributes(params[:order].merge(status: 'added_shipping_method'))
      redirect_to  new_creditcard_payment_path
    else
      current_order.errors.add(:base, 'Please select a shipping method')
      render 'edit_shipping_method'
    end
  end

  def paid_using_cc
    @page_title = 'Purchase is complete'
    @order = Order.find(params[:id])
  end

  def edit
    @page_title = 'Shipping information'
    unless current_order.shipping_address
      current_order.build_shipping_address
      current_order.shipping_address.use_for_billing = true
    end
    current_order.build_billing_address unless current_order.billing_address
  end

  def update
    @current_order.validate_email = true
    @current_order.email = params[:order][:email]

    # ensure email is entered and is valid
    current_order.valid?

    handle_shipping_address
    handle_billing_address unless current_order.shipping_address.use_for_billing

    if  current_order.errors.any? ||
        current_order.shipping_address.errors.any?  ||
        (current_order.billing_address && current_order.billing_address.errors.any?)
      render 'edit'
    else
      current_order.update_attributes!(status: 'added_shipping_info')
      redirect_to edit_shipping_method_order_path(current_order)
    end
  end

  private

  def handle_shipping_address
    _attributes = params[:order][:shipping_address_attributes]
    if current_order.shipping_address
      current_order.shipping_address.update_attributes(_attributes)
    else
      current_order.create_shipping_address(_attributes)
    end
  end

  def handle_billing_address
    _attributes = params[:order][:billing_address_attributes]
    if current_order.billing_address
      current_order.billing_address.update_attributes(_attributes)
    else
      current_order.create_billing_address(_attributes)
    end
  end

  private

  def set_instance_variables_for_shipping_method
    @page_title = 'Pick shipping method'
    @shipping_methods = current_order.available_shipping_methods
  end

end
