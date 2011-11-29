class CreditcardPaymentsController < ApplicationController

  theme :theme_resolver, only: [:new, :create]

  def new
    @creditcard = Creditcard.new
  end

  def create
    @creditcard = Creditcard.new(params[:creditcard])

    render action: 'new' and return unless @creditcard.valid?

    @gp = GatewayProcessor.new(creditcard: @creditcard, order: current_order)
    if @gp.authorize(current_order.price, @creditcard, current_order)
      reset_order
      redirect_to feedback_path(order_id: current_order.id)
    else
      @creditcard.errors.add(:base, 'Credit card was declined. Please try again with another credit card.')
      render action: "new"
    end
  end

end
