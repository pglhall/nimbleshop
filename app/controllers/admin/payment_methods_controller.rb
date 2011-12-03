class Admin::PaymentMethodsController < AdminController

  before_filter :load_payment_methods

  def index
    render
  end

  def show
    @payment_method = PaymentMethod.find(params[:id])
  end

  private

  def load_payment_methods
    @payment_methods = PaymentMethod.order('name asc').all
    @enabled_payment_methods = PaymentMethod.where(:enabled => true).all
  end

end
