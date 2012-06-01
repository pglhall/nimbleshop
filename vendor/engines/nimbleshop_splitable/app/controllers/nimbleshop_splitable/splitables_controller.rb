module NimbleshopSplitable
  class SplitablesController < ::Admin::PaymentMethodsController

    protect_from_forgery except: [:notify]

    before_filter :load_payment_method

    def notify
      Rails.logger.info "splitable callback received: #{params.to_yaml}"

      processor = NimbleshopSplitable::Processor.new(invoice: params[:invoice])

      if processor.acknowledge(params)
        render nothing: true
      else
        Rails.logger.info "webhook with data #{params.to_yaml} was rejected. error: #{processor.errors.join(',')}"
        render "error: #{error}", status: 403
      end
    end

    def update
      respond_to do |format|
        if @payment_method.update_attributes(post_params[:splitable])
          format.js  {
            flash[:notice] = "Splitable record was successfully updated"
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
      params.permit(splitable: [ :api_key, :api_secret, :expires_in, :mode] )
    end

    def load_payment_method
      @payment_method = NimbleshopSplitable::Splitable.first
    end

  end
end
