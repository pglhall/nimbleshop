class Admin::PaymentMethodsController < AdminController

  before_filter :load_payment_methods

  def index
    render
  end

  def show
    @payment_method = PaymentMethod.find(params[:id])
  end

  def update
    puts params.inspect
    @payment_method = PaymentMethod.find(params[:id])
    enabled = params[:payment_method][:enabled] == '0' ? false : true
    @payment_method.enabled = enabled
    @payment_method.save
    @payment_method.update_attributes(enabled: enabled)
    if enabled
      redirect_to admin_payment_method_path(@payment_method)
    else
      redirect_to admin_payment_methods_path
    end
  end

  private

  def load_payment_methods
    @payment_methods = PaymentMethod.order('name asc').all
    @enabled_payment_methods = PaymentMethod.where(:enabled => true).all
  end

end
