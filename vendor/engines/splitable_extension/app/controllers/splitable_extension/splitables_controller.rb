module SplitableExtension
  class SplitablesController < ::Admin::PaymentMethodsController

    before_filter :load_payment_method

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
        if @payment_method.update_attributes(post_params)
          format.html { redirect_to splitable_path, notice: 'Splitable record was successfully updated' }
        else
          format.html { render action: "edit" }
        end
      end
    end

    private

      def post_params
        params.slice( :api_key, :api_secret, :submission_url, :logo_url, :expires_in )
      end

      def load_payment_method
        @payment_method = PaymentMethod.find_by_permalink!('splitable')
      end

  end
end
