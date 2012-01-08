class CreditcardPaymentsController < ApplicationController

  theme :theme_resolver, only: [:new, :create]

  def new
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


      addr = order.shipping_address.use_for_billing ? order.shipping_address : order.billing_address
      @creditcard = Creditcard.new(params[:creditcard].merge(address1: addr.address1,
                                                             address2: addr.address2,
                                                             first_name: addr.first_name,
                                                             last_name: addr.last_name,
                                                             state: addr.state,
                                                             zipcode: addr.zipcode))
      render action: 'new' and return unless @creditcard.valid?

      gp = GatewayProcessor.new(payment_method_permalink: 'authorize-net')
      if gp.authorize(order.grand_total, @creditcard, order)

        payment_method = PaymentMethod.find_by_permalink!('authorize-net')
        order.update_attributes!(payment_method: payment_method, payment_status: 'authorized')

        reset_order
        redirect_to paid_order_path(current_order)
      else
        @creditcard.errors.add(:base, t(:credit_card_declined_message))
        render action: "new"
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
