class OrdersController < ApplicationController

  layout 'slim'
  theme :theme_resolver, only: [:edit, :update]

  def edit
    current_order.build_shipping_address unless current_order.shipping_address
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

    checkout_with = session[:checkout_with]

    if checkout_with == 'with_splitable'
      redirect_to Splitable.url(current_order) and return
    end

    if current_shop.gateway.blank?
      render text: "Payment gateway is not configured. Please visit '/admin/payment_gateway' and setup the payment gateway."
    elsif current_shop.gateway == 'website_payments_standard'
      redirect_to current_order.paypal_url
    elsif current_shop.gateway == 'AuthorizeNet'
      redirect_to  new_creditcard_payment_path
    else
      render text: "shop has payment_gateway value as '#{current_shop.payment_gateway}'. That seems to be an invalid value."
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
