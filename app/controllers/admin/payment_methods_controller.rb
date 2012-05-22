class Admin::PaymentMethodsController < AdminController

  before_filter :load_payment_methods

  layout 'payment_method'

  def index
    @page_title = 'Payment methods'
    if PaymentMethod.enabled.count == 0
      flash.now[:error] = 'You have not enabled any payment method. User wil not be able to make payment'
    end
    render layout: 'payment_method'
  end

  def update
    @payment_method = PaymentMethod.find_by_id!(params[:id])

    enabled = params[:enabled]  ? true : false
    @payment_method.update_attributes(enabled: enabled)

    unless enabled
      redirect_to admin_payment_methods_path
      return
    end

    redirect_to case @payment_method.permalink
                  when 'splitable'
                    nimbleshop_splitable.splitable_path

                  when 'authorizedotnet'
                    nimbleshop_authorizedotnet.authorizedotnet_path

                  when 'paypalwp'
                    nimbleshop_paypalwp.paypalwp_path
                  else
                     raise "#{@payment_method.permalink} is wrong"
                  end
  end

  private

  def load_payment_methods
    @payment_methods = PaymentMethod.order('id asc')
    @enabled_payment_methods = PaymentMethod.where(enabled: true)
  end

end
