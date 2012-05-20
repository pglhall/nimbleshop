module NimbleshopPaypalwp
  class PaypalwpsController < ::Admin::PaymentMethodsController

    protect_from_forgery except: [ :notify ]

    before_filter :load_payment_method, except: [ :notify ]

    def notify
      handler = PaypalExtension::Billing.new(raw_post: request.raw_post)
      handler.authorize
      render nothing: true
    end

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
        if @payment_method.update_attributes(post_params[:paypalwp])
          format.html { redirect_to paypalwp_path, notice: 'Paypal record was successfully updated' }
        else
          format.html { render action: "edit" }
        end
      end
    end

    private

    def post_params
      params.permit(paypalwp: [:merchant_email, :standard_use_ssl, :paymentaction])
    end

    def load_payment_method
      @payment_method = NimbleshopPaypalwp::Paypalwp.first
    end

  end
end
