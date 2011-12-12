class FeedbacksController < ApplicationController

  layout 'thin'
  theme :theme_resolver, only: [:show]

  def show
    @order  = Order.find(params[:order_id])
  end

  def splitable
    render
  end

end
