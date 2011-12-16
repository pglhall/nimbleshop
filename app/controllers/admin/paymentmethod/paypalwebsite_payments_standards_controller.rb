class Admin::Paymentmethod::PaypalwebsitePaymentsStandardsController < Admin::PaymentMethodsController

  def show
    @payment_method = PaymentMethod.find_by_permalink('paypal-website-payments-standard')
  end

  def edit
    @payment_method = PaymentMethod.find_by_permalink('paypal-website-payments-standard')
  end

  def update
    @payment_method = PaymentMethod.find_by_permalink('paypal-website-payments-standard')
    @payment_method.image_on_checkout_page
    @payment_method.merchant_email_address = params[:merchant_email_address]
    @payment_method.return_url = params[:return_url]
    @payment_method.notify_url = params[:notify_url]
    @payment_method.request_submission_url = params[:request_submission_url]

    @payment_method.save
    redirect_to admin_paymentmethod_paypalwebsite_payments_standard_path, notice: 'Successfuly updated'
  end

end
