module NimbleshopPaypalwp
  class PaypalwpsController < ::Admin::PaymentMethodsController

    protect_from_forgery except: [ :notify ]

    before_filter :load_payment_method, except: [ :notify ]

    def notify
      handler = PaypalExtension::Billing.new(raw_post: request.raw_post)
      handler.authorize
      render nothing: true
    end

    def update
      respond_to do |format|
        if @payment_method.update_attributes(post_params[:paypalwp])
          format.js  {
            flash[:notice] = "Paypal record was successfully updated"
            render js: "window.location = '/admin/payment_methods'"
          }
        else
          msg =  @payment_method.errors.full_messages.first
          error =  %Q[alert("#{msg}")]
          format.js { render js: error }
        end
      end
    end

    private

    def post_params
      params.permit(paypalwp: [:merchant_email, :standard_use_ssl, :paymentaction, :mode])
    end

    def load_payment_method
      @payment_method = NimbleshopPaypalwp::Paypalwp.first
    end

  end
end
