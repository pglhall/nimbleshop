class OrdersController < ApplicationController

  before_filter :verify_current_order,  only: [:edit_shipping_method, :update_shipping_method, :edit, :update]
  before_filter :set_shipping_method,   only: [:edit_shipping_method, :update_shipping_method]
  before_filter :reset_order, only: [ :show ]

  respond_to :html

  theme :theme_resolver

  def show
    @page_title     = 'Purchase is complete'
    @order          = Order.find_by_number!(params[:id])
    @payment_method = @order.payment_method

    respond_with(@order)
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
