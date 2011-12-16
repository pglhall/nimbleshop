class Admin::Paymentmethod::SplitablesController < Admin::PaymentMethodsController

  before_filter :load_payment_method

  def show
    render
  end

  def edit
    render
  end

  def update
    @payment_method.api_key = params[:api_key]
    @payment_method.save
    redirect_to admin_paymentmethod_splitable_path, notice: 'Successfuly updated'
  end

  private

  def load_payment_method
    @payment_method = PaymentMethod.find_by_permalink!('splitable')
  end

end
