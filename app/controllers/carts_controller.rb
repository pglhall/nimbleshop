class CartsController < ApplicationController

  theme :theme_resolver, only: [:show]

  def show
    @page_title = 'Your cart'
    @line_items = current_order.blank? ? [] : current_order.line_items(:include => :product).order('id')
  end

  def create
    raise 'boom think it is not needed'
  end

  def add
    product = Product.find_by_permalink!(params[:permalink])
    session[:order_id] = Order.create!.id unless current_order
    current_order.add(product)
    redirect_to cart_url
  end

  def update
    if params[:payment_method_permalink]
      session[:payment_method_permalink] = params[:payment_method_permalink].keys.first
      redirect_to edit_order_url(current_order) and return
    end

    params[:updates].each do |permalink, quantity|
      product = Product.find_by_permalink!(permalink)
      current_order.set_quantity(product, quantity.to_i)
    end
    redirect_to cart_url
  end

  def destroy
    product = Product.find(params[:product_id])
    current_order.remove(product)
    redirect_to cart_url
  end

end
