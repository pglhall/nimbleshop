class CartsController < ApplicationController

  theme :theme_resolver, only: [:show]

  respond_to :html

  # this is mostly used for development purpose
  def reset
    reset_session
    redirect_to root_url
  end

  def show
    @line_items = current_order.blank? ? [] : current_order.line_items(include: :product).order('id')
    respond_with @line_items
  end

  def add
    product = Product.find_by_permalink!(params[:permalink])
    session[:order_id] = Order.create!.id unless current_order
    current_order.add(product)
    redirect_to cart_url
  end

  def checkingout
    redirect_to new_order_checkout_shipping_address_path(current_order)
  end

  def update
    current_order.update_quantity(params[:updates])
    redirect_to cart_url
  end

end
