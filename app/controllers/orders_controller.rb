class OrdersController < ApplicationController

  layout 'thin'
  theme :theme_resolver, only: [:edit, :update]

  def edit
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

    case session[:checkout_with]
    when 'with_splitable'
      redirect_to Splitable.url(current_order) and return
    when 'with_paypal'
      redirect_to current_order.paypal_url
    when 'with_authorize_net'
      redirect_to  new_creditcard_payment_path
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

end
