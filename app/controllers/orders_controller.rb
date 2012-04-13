class OrdersController < ApplicationController
  before_filter :verify_current_order,  only: [:edit_shipping_method, :update_shipping_method, :edit, :update]
  before_filter :set_shipping_method,   only: [:edit_shipping_method, :update_shipping_method]
  before_filter :reset_order, only: [ :paid ]

  respond_to :html

  theme :theme_resolver

  def edit_shipping_method
    @page_title = 'Pick shipping method'

    respond_with(current_order)
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
    @page_title     = 'Purchase is complete'
    @order          = Order.find_by_number!(params[:id])
    @payment_method = PaymentMethod.find_by_permalink!('authorize-net')

    respond_with(@order)
  end

  # TODO find a better action name. Name of action is edit but it records
  # the shipping information for order
  def edit
    @page_title = 'Shipping information'
    current_order.initialize_addresses

    # TODO add a new method on order so that following code could be
    #
    # current_order.shippable_countries
    @countries = ShippingMethod.available_for_countries(current_order.line_items_total)

    respond_with(current_order)
  end

  def update
    if current_order.update_attributes(params[:order].merge(validate_email: true))
      redirect_to edit_shipping_method_order_path(current_order)
    else
      @countries = ShippingMethod.available_for_countries(current_order.line_items_total)
      current_order.initialize_addresses
      render 'edit'
    end
  end

  private


  def verify_current_order
    unless current_order
      redirect_to root_path
    end
  end

  def set_shipping_method
    @shipping_methods = Array.wrap(current_order.available_shipping_methods)
  end
end
