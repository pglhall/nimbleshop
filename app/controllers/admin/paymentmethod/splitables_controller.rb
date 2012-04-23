class Admin::Paymentmethod::SplitablesController < Admin::PaymentMethodsController

  before_filter :load_payment_method!

  def show
    @page_title = 'splitable'
  end

  def edit
    @page_title = 'edit splitable'
  end

  def update
    if @payment_method.update_attributes(post_params)
      redirect_to admin_paymentmethod_splitable_path, notice: 'Successfuly updated'
    else
      render :edit
    end
  end

  private

    def post_params
      params.slice( :splitable_api_key, :splitable_api_secret, :splitable_submission_url, :splitable_logo_url, :splitable_expires_in )
    end

    def load_payment_method!
      @payment_method = PaymentMethod.find_by_permalink!('splitable')
    end

end
