class Admin::PaymentMethodsController < AdminController

  before_filter :load_payment_methods

  def index
    render
  end

  def show
    @payment_method = PaymentMethod.find(params[:id])
  end

  def update
    @payment_method = PaymentMethod.find(params[:id])
    enabled = params[:enabled]  ? true : false
    @payment_method.update_attributes(enabled: enabled)
    if enabled
      case @payment_method.permalink
      when 'splitable'
        redirect_to admin_paymentmethod_splitable_path
      when 'authorize-net'
        redirect_to admin_paymentmethod_authorizedotnet_path
      when 'paypal-website-payments-standard'
        redirect_to admin_paymentmethod_paypalwebsite_payments_standard_path
      end
    else
      redirect_to admin_payment_methods_path
    end
  end

  private

  def load_payment_methods
    @payment_methods = PaymentMethod.order('name asc').all
    @enabled_payment_methods = PaymentMethod.where(enabled: true).all
  end

end
