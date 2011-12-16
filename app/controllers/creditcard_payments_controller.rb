class CreditcardPaymentsController < ApplicationController

  theme :theme_resolver, only: [:new, :create]

  def new
    @page_title = 'Make payment using credit card'
    @page_sub_title = 'All payments are secure and encrypted. We never store your credit card information.'
    @creditcard = Creditcard.new
  end

  def create
    order = current_order
    @creditcard = Creditcard.new(params[:creditcard])

    render action: 'new' and return unless @creditcard.valid?

    @gp = GatewayProcessor.new(payment_method_permalink: session[:payment_method_permalink])
    if @gp.authorize(current_order.price, @creditcard, order)
      current_order.update_attributes(status: 'authorized')
      reset_order
      render text: 'you paid'
    else
      @creditcard.errors.add(:base, 'Credit card was declined. Please try again with another credit card.')
      render action: "new"
    end
  end

end
