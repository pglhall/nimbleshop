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
      redirect_to new_order_shipping_address_path(current_order)
    else
      params[:updates].each do |product_id, quantity|
        current_order.set_quantity(product_id, quantity.to_i)
      end
      redirect_to cart_url
    end
  end

end
