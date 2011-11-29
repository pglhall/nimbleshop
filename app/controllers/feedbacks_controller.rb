class FeedbacksController < ApplicationController

  theme :theme_resolver, only: [:show]

  def show
    @order  = Order.find(params[:order_id])
  end

end
