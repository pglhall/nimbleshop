#TODO add respond_to
module NimbleshopSplitable
  class PaymentsController < ::Admin::PaymentMethodsController

    def create
      order = main_app.current_order
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
