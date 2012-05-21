#TODO add respond_to
module NimbleshopAuthorizedotnet
  class PaymentsController < ::Admin::PaymentMethodsController

    def create
      order = Order.find_by_id(session[:order_id])
      address_attrs     = order.final_billing_address.to_credit_card_attributes
      creditcard_attrs  = params[:creditcard].merge(address_attrs)
      creditcard       = Creditcard.new(creditcard_attrs)
      handler           = NimbleshopAuthorizedotnet::Billing.new(order)

      default_action = Shop.first.default_creditcard_action
      if handler.send(default_action, creditcard: creditcard)
        @url = main_app.order_path(order)
      else
        @error = creditcard.errors.full_messages.first
      end

      respond_to do |format|
        format.js do
          if @url
            render js: "window.location='#{@url}'"
          else 
            render js: "alert('#{@error}')"
          end
        end
      end


    end

  end
end
