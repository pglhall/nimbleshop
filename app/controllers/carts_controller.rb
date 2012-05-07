class CartsController < ApplicationController

  theme :theme_resolver, only: [:show]

  respond_to :html

  def show
    @page_title = 'Your cart'
    @line_items = current_order.blank? ? [] : current_order.line_items(include: :product).order('id')
    respond_with @line_items
  end

  def add
    product = Product.find_by_permalink!(params[:permalink])
    session[:order_id] = Order.create!.id unless current_order
    record = Variant.record_for_given_variations(params[:variation1_value],
                                                 params[:variation2_value],
                                                 params[:variation3_value])
    if record
      current_order.add(product, record)
    else
      current_order.add(product)
    end
    redirect_to cart_url
  end

  def update
    if params[:checkout]
      redirect_to edit_order_url(current_order)
    else
      params[:updates].each do |product_id, quantity|
        current_order.set_quantity(product_id, quantity.to_i)
      end
      redirect_to cart_url
    end
  end

end
