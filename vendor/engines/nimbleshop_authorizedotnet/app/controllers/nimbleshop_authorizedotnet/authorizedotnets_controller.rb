#TODO add respond_to

module NimbleshopAuthorizedotnet
  class AuthorizedotnetsController < ::Admin::PaymentMethodsController

    before_filter :load_payment_method

    def show
      @page_title = 'Authorize.net payment information'
      respond_to do |format|
        format.html # show.html.erb
      end
    end

    def edit
      @page_title = 'Edit Authorize.net payment information'
    end

   def update
      if @payment_method.update_attributes(post_params)
        redirect_to authorizedotnet_path , notice: 'Authorize.net record was successfuly updated'
      else
        render :edit
      end
    end

    private

    def post_params
        params.slice(:login_id, :transaction_key, :use_ssl, :company_name_on_creditcard_statement )
    end

    def load_payment_method
      @payment_method = NimbleshopAuthorizedotnet::Authorizedotnet.first
    end

  end
end
