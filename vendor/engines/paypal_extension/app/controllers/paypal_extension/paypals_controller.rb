module PaypalExtension
  class PaypalsController < ::Admin::PaymentMethodsController

    before_filter :load_payment_method

    def show
      @page_title = 'Paypal payment information'
      respond_to do |format|
        format.html # show.html.erb
      end
    end

    def edit
      @page_title = 'Edit Paypal payment information'
    end

    def update
      respond_to do |format|
        if @payment_method.update_attributes(post_params)
          format.html { redirect_to paypal_path, notice: 'Paypal record was successfully updated' }
        else
          format.html { render action: "edit" }
        end
      end
    end

    private

      def post_params
        params.slice(:merchant_email, :standard_use_ssl, :paymentaction)
      end

      def load_payment_method
        @payment_method = PaymentMethod.find_by_permalink!('paypal-website-payments-standard')
      end

  end
end
