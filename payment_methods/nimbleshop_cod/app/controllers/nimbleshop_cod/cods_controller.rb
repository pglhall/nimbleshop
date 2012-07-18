module NimbleshopCod

  class CodsController < ::Admin::PaymentMethodsController

    before_filter :load_payment_method

    def destroy
      respond_to do |format|
        if @payment_method.destroy
          format.js {
            flash[:notice] = 'Cash on delivery record was successfully deleted'
            render js: "window.location = '/admin/payment_methods'"
          }
        else
          format.js { render js: 'Cash on delivery record could not be deleted. Please try again later.' }
        end
      end
    end

    private

    def load_payment_method
      @payment_method = NimbleshopCod::Cod.first
    end

  end

end
