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
    if params[:payment_choice] == 'splitable'
      redirect_to PaymentMethod::Splitable.first.url(current_order, request) and return
    elsif params[:payment_choice] == 'paypal'
      # it is possible that a buyer hit a back button and went back to shop and made some changes to the cart
      # and then is using paypal again to checkout
      if paypal_record = PaypalTransaction.find_by_invoice(current_order.number)
        paypal_record.update_attributes!(amount: current_order.grand_total)
      else
        PaypalTransaction.create!(order: current_order, amount: current_order.grand_total, invoice: current_order.number)
      end
      redirect_to current_order.paypal_url and return
    end

    order = current_order
    @creditcard = Creditcard.new(params[:creditcard])
    addr = current_order.shipping_address.use_for_billing ? current_order.shipping_address : current_order.billing_address
    @creditcard.address1 = addr.address1
    @creditcard.address2 = addr.address2
    @creditcard.first_name = addr.first_name
    @creditcard.last_name = addr.last_name
    @creditcard.state = addr.state
    @creditcard.zipcode = addr.zipcode

    render action: 'new' and return unless @creditcard.valid?

    @gp = GatewayProcessor.new(payment_method_permalink: session[:payment_method_permalink])
    if @gp.authorize(current_order.grand_total, @creditcard, order)
      current_order.update_attributes(status: 'authorized')
      reset_order
      redirect_to paid_using_creditcard_order_path(current_order)
    else
      @creditcard.errors.add(:base, t(:credit_card_declined_message))
      render action: "new"
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
      return current_order.paypal_url
    end
  end

end
