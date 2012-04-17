class Admin::Paymentmethod::PaypalwebsitePaymentsStandardsController < Admin::PaymentMethodsController

  before_filter :load_payment_method

  def show
    @page_title = 'paypal'
  end

  def edit
    @page_title = 'edit paypal'
  end

  def update
    @payment_method.merchant_email_address = params[:merchant_email_address]
    @payment_method.return_url             = params[:return_url]
    @payment_method.notify_url             = params[:notify_url]
    @payment_method.request_submission_url = params[:request_submission_url]

    @payment_method.save
    redirect_to admin_paymentmethod_paypalwebsite_payments_standard_path, notice: 'Successfuly updated'
  end

  private

    def load_payment_method
      @payment_method = PaymentMethod.find_by_permalink!('paypal-website-payments-standard')
    end

end
