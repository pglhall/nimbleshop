class OrdersController < ApplicationController

  before_filter :set_instance_variables_for_shipping_method, only: [:edit_shipping_method, :update_shipping_method]

  theme :theme_resolver

  def edit_shipping_method
    render
  end

  def update_shipping_method
    if params[:order].present? && params[:order].keys.include?('shipping_method_id')
      current_order.update_attributes(params[:order])

      case session[:payment_method_permalink]
      when 'splitable'
        redirect_to PaymentMethod::Splitable.first.url(current_order)
      when 'paypal-website-payments-standard'
        redirect_to current_order.paypal_url
      when 'authorize-net'
        redirect_to  new_creditcard_payment_path
      end
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
    unless @current_order.save
      render 'edit' and return if @current_order.errors.any?
    end

    handle_shipping_address
    render 'edit' and return if current_order.shipping_address.errors.any?

    unless current_order.shipping_address.use_for_billing
      handle_billing_address
      render 'edit' and return if current_order.billing_address.errors.any?
    end

    redirect_to edit_shipping_method_order_path(current_order)
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
