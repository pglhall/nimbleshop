class CreditcardPaymentsController < ApplicationController

  theme :theme_resolver, only: [:new, :create]

  def new
    @page_title = 'payment using credit card'
    @creditcard = Creditcard.new
  end

  def create
    order = current_order
    @creditcard = Creditcard.new(params[:creditcard])

    render action: 'new' and return unless @creditcard.valid?

    @gp = GatewayProcessor.new(creditcard: @creditcard, order: order)
    if @gp.authorize(current_order.price, @creditcard, order)
      current_order.update_attributes(status: 'authorized')
      reset_order
      redirect_to feedback_path(order_id: order.id)
    else
      @creditcard.errors.add(:base, 'Credit card was declined. Please try again with another credit card.')
      render action: "new"
    end
  end

end
