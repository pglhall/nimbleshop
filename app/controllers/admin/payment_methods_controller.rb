class Admin::PaymentMethodsController < AdminController

  before_filter :load_payment_methods

  layout 'payment_method'

  def index
    if PaymentMethod.enabled.count == 0
      flash.now[:error] = 'You have not enabled any payment method. User wil not be able to make payment'
    end
    render layout: 'payment_method'
  end

  private

  def load_payment_methods
    @payment_methods = PaymentMethod.order('id asc')
  end

end
