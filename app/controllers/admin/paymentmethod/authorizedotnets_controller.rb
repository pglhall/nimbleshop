class Admin::Paymentmethod::AuthorizedotnetsController < Admin::PaymentMethodsController

  before_filter :load_payment_method

  def show
    @page_title = 'authorize.net'
  end

  def edit
    @page_title = 'edit authorize.net'
  end

  def update
    if @payment_method.update_attributes(post_params)
      redirect_to admin_paymentmethod_authorizedotnet_path, notice: 'Successfuly updated'
    else
      render :edit
    end
  end

  private

    def post_params
      params.slice(:authorize_net_login_id, 
                   :authorize_net_transaction_key,
                   :authorize_net_use_ssl,
                   :authorize_net_company_name_on_creditcard_statement )
    end

    def load_payment_method
      @payment_method = PaymentMethod.find_by_permalink!('authorize-net')
    end

end
