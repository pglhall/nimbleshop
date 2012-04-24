class Admin::Paymentmethod::PaypalwebsitePaymentsStandardsController < Admin::PaymentMethodsController

  before_filter :load_payment_method

  def show
    @page_title = 'paypal'
  end

  def edit
    @page_title = 'edit paypal'
  end

  def update
    if @payment_method.update_attributes(post_params)
      redirect_to admin_paymentmethod_paypalwebsite_payments_standard_path, notice: 'Successfuly updated'
    else
      render :edit
    end
  end

  private

    def post_params
      params.slice(:paypal_website_payments_standard_merchant_email,
                   :paypal_website_payments_standard_use_ssl,
                   :paypal_website_payments_standard_paymentaction)
    end

    def load_payment_method
      @payment_method = PaymentMethod.find_by_permalink!('paypal-website-payments-standard')
    end
end
