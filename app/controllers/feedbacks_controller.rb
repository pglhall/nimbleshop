class FeedbacksController < ApplicationController

  theme :theme_resolver, only: [:show]

  respond_to :html

  def show
    @order  = Order.find(params[:order_id])
    respond_with @order
  end

  def splitable
    render
  end

end
