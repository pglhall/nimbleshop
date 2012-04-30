class Admin::Paymentmethod::SplitablesController < Admin::PaymentMethodsController

  before_filter :load_payment_method!

  layout 'payment_method'

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
      params.slice( :api_key,
                    :api_secret,
                    :submission_url,
                    :logo_url,
                    :expires_in )
    end

    def load_payment_method!
      @payment_method = PaymentMethod.find_by_permalink!('splitable')
    end

end
