class PaymentProcessorsController < ApplicationController

  theme :theme_resolver, only: [:new, :create]

  # TODO if Authorize.net is not used then there is no need to force_ssl
  force_ssl :if => lambda { |controller|
    Rails.env.production? || Rails.env.staging?
  }

  def new
    # If there is only one payment method enabled and that payment method
    # splitable or paypal then just redirect to that page
    if url = payment_method_url
      redirect_to url
    else
      @page_title = 'Make payment'
      @creditcard = Creditcard.new
    end
  end

  def create
    order = current_order

    case params[:payment_choice]
    when 'splitable'
      payment_method = PaymentMethod::Splitable.first
      order.update_attributes!(payment_method: payment_method)
      redirect_to payment_method.url(order, request)

    when 'paypal'

      payment_method = PaymentMethod::PaypalWebsitePaymentsStandard.first
      order.update_attributes!(payment_method: payment_method)
      redirect_to payment_method.url(order)
    else

      @creditcard = Creditcard.build_for_payment_processing(params, order)

      render action: 'new' and return unless @creditcard.valid?

      pp = PaymentProcessor.new(order.grand_total, @creditcard, order)
      case Shop.first.default_creditcard_action
      when 'authorize'
        pp.authorize
      when 'purchase'
        pp.purchase
      end
      if @creditcard.errors.any?
        render(action: :new)
      else
        reset_order
        redirect_to(paid_order_path(current_order))
      end

    end
  end

  private

  def payment_method_url
    return nil if PaymentMethod.enabled.count > 1

    permalink = PaymentMethod.enabled.first.permalink
    return nil if permalink == 'authorize-net'
    case permalink
    when 'splitable'
      return PaymentMethod::Splitable.first.url(current_order, request)
    when 'paypal-website-payments-standard'
      return PaymentMethod::PaypalWebsitePaymentsStandard.first.url(current_order)
    end
  end

end
