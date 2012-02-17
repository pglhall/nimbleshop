class Admin::Paymentmethod::SplitablesController < Admin::PaymentMethodsController

  before_filter :load_payment_method!

  def show
    @page_title = 'splitable'
  end

  def edit
    @page_title = 'edit splitable'
  end

  def update
    @payment_method.splitable_api_key        = params[:splitable_api_key]
    @payment_method.splitable_api_secret     = params[:splitable_api_secret]
    @payment_method.splitable_submission_url = params[:splitable_submission_url]
    @payment_method.splitable_logo_url       = params[:splitable_logo_url]
    @payment_method.splitable_expires_in     = params[:splitable_expires_in]
    @payment_method.save
    redirect_to admin_paymentmethod_splitable_path, notice: 'Successfuly updated'
  end

  private

  def load_payment_method!
    @payment_method = PaymentMethod.find_by_permalink!('splitable')
  end

end
