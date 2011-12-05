class CartsController < ApplicationController

  theme :theme_resolver, only: [:show]

  def show
    @page_title = 'cart'
    @line_items = current_order.blank? ? [] : current_order.line_items(:include => :product).order('id')
  end

  def create
    if params[:checkout]
      checkout_with = params[:checkout].keys.first
      session[:checkout_with] = checkout_with
      redirect_to edit_order_url and return
    end

    params[:updates].each do |permalink, quantity|
      product = Product.find_by_permalink!(permalink)
      current_order.set_quantity(product, quantity.to_i)
    end
    redirect_to cart_url
  end

  def add
    product = Product.find_by_permalink!(params[:permalink])
    session[:order_id] = Order.create!.id unless current_order
    current_order.add(product)
    redirect_to cart_url
  end

  def update
    product = current_order.products.find(params[:product_id])
    current_order.set_quantity(product, params[:quantity].to_i)
    respond_to do |format|
      format.html { redirect_to cart_url }
      format.js
    end
  end

  def destroy
    product = Product.find(params[:product_id])
    current_order.remove(product)
    redirect_to cart_url
  end

end
