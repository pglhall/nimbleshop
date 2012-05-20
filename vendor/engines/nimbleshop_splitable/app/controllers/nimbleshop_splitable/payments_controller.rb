#TODO add respond_to
module NimbleshopSplitable
  class PaymentsController < ::Admin::PaymentMethodsController

    def create
      render text: 'paid'
    end

  end
end
