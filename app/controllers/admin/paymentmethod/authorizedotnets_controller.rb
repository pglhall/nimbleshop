class Admin::Paymentmethod::AuthorizedotnetsController < Admin::PaymentMethodsController

  def show
    @payment_method = PaymentMethod.find_by_permalink('authorize-net')
  end

  def edit
    @payment_method = PaymentMethod.find_by_permalink('authorize-net')
  end

  def update
    @payment_method = PaymentMethod.find_by_permalink('authorize-net')
    @payment_method.write_preference(:login_id, params[:login_id])
    @payment_method.write_preference(:transaction_key, params[:transaction_key])
    @payment_method.write_preference(:company_name_on_creditcard_statement, params[:company_name_on_creditcard_statement])
    @payment_method.save!
    redirect_to admin_paymentmethod_authorizedotnet_path, notice: 'Successfuly updated'
  end

end
