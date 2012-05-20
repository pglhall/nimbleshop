#TODO add respond_to
module NimbleshopAuthorizedotnet
  class PaymentsController < ::Admin::PaymentMethodsController

    def create
      render text: 'paid'
    end

  end
end
