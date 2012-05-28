class Checkout::PaymentsController < ApplicationController

  theme :theme_resolver, only: [:new, :create]

  force_ssl :if => lambda { |controller| controller.use_ssl }

  def new
    @page_sub_title = 'All payments are secure and encrypted. We never store your credit card information.'
    @creditcard = Creditcard.new
    render text: 'No payment method is enabled. Please enable atleast one payment method.' if PaymentMethod.enabled.count == 0
  end

  def use_ssl
    return false if Rails.env.test?
    PaymentMethod.enabled.find { |i| i.use_ssl? }
  end

end
