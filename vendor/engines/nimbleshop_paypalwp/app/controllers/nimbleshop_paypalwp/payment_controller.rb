#TODO add respond_to
module NimbleshopPaypalwp
  class PaymentsController < ::Admin::PaymentMethodsController

    def create
      render text: 'paid'
    end

  end
end
