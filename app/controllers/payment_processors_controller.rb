class PaymentProcessorsController < ApplicationController

  theme :theme_resolver, only: [:new, :create]

  # TODO if Authorize.net is not used then there is no need to force_ssl
  force_ssl :if => lambda { |_| Rails.env.production? || Rails.env.staging? }

  def set_splitable_data
    order = current_order
    product = order.line_items.first.product
    api_notify_url = request.protocol + request.host_with_port + '/payment_notifications/splitable'

  end

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
      error, url = payment_method.process_request(order, request)

      if error
        render text: error
      else
        redirect_to url
      end
    else
      address_attrs = order.final_billing_address.to_credit_card_attributes
      @creditcard   = Creditcard.new(params[:creditcard].merge(address_attrs))
      unless PaymentProcessor.new(@creditcard, order).process
        render action: :new  and return
      end

      redirect_to paid_order_path(id: current_order, payment_method: :credit_card)
    end
  end

  private

    def payment_method_url
      return nil if PaymentMethod.enabled.count != 1

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
