class PaymentProcessorsController < ApplicationController

  theme :theme_resolver, only: [:new, :create]

  force_ssl :if => lambda { |controller| controller.use_ssl }

  def new
    @page_title = 'Make payment'
    @page_sub_title = 'All payments are secure and encrypted. We never store your credit card information.'
    @creditcard = Creditcard.new
    render text: 'No payment method is enabled. Please enable atleast one payment method.' if PaymentMethod.enabled.count == 0
  end

  def create
    raise 'booooom'
    order = current_order

    case params[:payment_choice]
    when 'splitable'
      handler     = NimbleshopSplitable::Billing.new(order: order)
      error, url  = handler.create_split(request: request)

      if error
        render text: error
      else
        redirect_to url
      end
    else
      address_attrs     = order.final_billing_address.to_credit_card_attributes
      creditcard_attrs  = params[:creditcard].merge(address_attrs)
      @creditcard       = Creditcard.new(creditcard_attrs)
      handler           = NimbleshopAuthorizedotnet::Billing.new(order)

      a = Shop.first.default_creditcard_action
      if handler.send(a, creditcard: @creditcard)
        redirect_to current_order
      else
        render action: :new
      end
    end
  end

  def use_ssl
    return false if Rails.env.test?
    PaymentMethod.enabled.find { |i| i.use_ssl == 'true' }
  end

end
