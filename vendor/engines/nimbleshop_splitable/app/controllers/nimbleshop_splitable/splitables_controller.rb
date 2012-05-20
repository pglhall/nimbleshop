module NimbleshopSplitable
  class SplitablesController < ::Admin::PaymentMethodsController

    protect_from_forgery except: [:notify]

    before_filter :load_payment_method

    def notify
      Rails.logger.info "splitable callback received: #{params.to_yaml}"

      handler = NimbleshopSplitable::Billing.new(invoice: params[:invoice])

      if handler.acknowledge(params)
        render nothing: true
      else
        Rails.logger.info "webhook with data #{params.to_yaml} was rejected. error: #{handler.errors.join(',')}"
        render "error: #{error}", status: 403
      end
    end

    def show
      @page_title = 'Splitable payment information'
      respond_to do |format|
        format.html # show.html.erb
      end
    end

    def edit
      @page_title = 'Edit Splitable payment information'
    end

    def update
      respond_to do |format|
        if @payment_method.update_attributes(post_params[:splitable])
          format.html { redirect_to splitable_path, notice: 'Splitable record was successfully updated' }
        else
          format.html { render action: "edit" }
        end
      end
    end

    private

    def post_params
      params.permit(splitable: [ :api_key, :api_secret, :submission_url, :logo_url, :expires_in] )
    end

    def load_payment_method
      @payment_method = NimbleshopSplitable::Splitable.first
    end

  end
end
