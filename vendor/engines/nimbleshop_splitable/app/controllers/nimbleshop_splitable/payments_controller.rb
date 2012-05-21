#TODO add respond_to
module NimbleshopSplitable
  class PaymentsController < ::Admin::PaymentMethodsController

    def create
      order = Order.find_by_id(session[:order_id])
      handler     = NimbleshopSplitable::Billing.new(order: order)
      error, url  = handler.create_split(request: request)

      if error
        render text: error
      else
        redirect_to url
      end
    end

  end
end
