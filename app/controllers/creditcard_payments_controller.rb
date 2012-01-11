class PaymentProcessor
  attr_accessor :order, :creditcard, :gateway_processor, :payment_method, :amount

  def initialize(_amount, _creditcard, _order)
    @amount = _amount
    @creditcard = _creditcard
    @order = _order
    @payment_method = PaymentMethod.find_by_permalink!('authorize-net')
    @gateway_processor = build_gateway_processor
  end

  def purchase
    handle_action(:purchase, :purchased)
  end

  def authorize
    handle_action(:authorize, :authorized)
  end

  def handle_action(action, status)
    if gateway_processor.send(action)
      order.send(status)
      order.update_attributes!(payment_method: payment_method)
    else
      creditcard.errors.add(:base, t(:credit_card_declined_message))
    end
  end

  def build_gateway_processor
    GatewayProcessor.new(payment_method_permalink: 'authorize-net',
                        amount: amount,
                        creditcard: creditcard,
                        order: order)
  end
end

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

      pp = PaymentProcessor.new(order.grand_total, @creditcard, order)
      case Shop.first.default_creditcard_action
      when 'authorize'
        pp.authorize
        if @creditcard.errors.any?
          render(action: :new)
        else
          reset_order
          redirect_to(paid_order_path(current_order))
        end
      when 'purchase'
        pp.purchase
        if @creditcard.errors.any?
          render(action: :new)
        else
          reset_order
          redirect_to(paid_order_path(current_order))
        end
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
