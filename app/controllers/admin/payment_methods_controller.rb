class Admin::PaymentMethodsController < AdminController

  before_filter :load_payment_methods

  layout 'payment_method'

  def index
    @page_title = 'Payment methods'
    if PaymentMethod.enabled.count == 0
      flash.now[:error] = 'You have not configured any payment method. User wil not be able to make payment'
    end
    render layout: 'payment_method'
  end

  def update
    @payment_method = PaymentMethod.find(params[:id])
    enabled = params[:enabled]  ? true : false
    @payment_method.update_attributes(enabled: enabled)
    redirect_to admin_payment_methods_path && return unless enabled

    case @payment_method.permalink
    when 'splitable'
      redirect_to admin_paymentmethod_splitable_path
    when 'authorize-net'
      redirect_to admin_paymentmethod_authorizedotnet_path
    when 'paypal-website-payments-standard'
      redirect_to admin_paymentmethod_paypalwebsite_payments_standard_path
    end
  end

  private

    def load_payment_methods
      @payment_methods = PaymentMethod.order('name asc')
      @enabled_payment_methods = PaymentMethod.where(enabled: true)
    end

end
