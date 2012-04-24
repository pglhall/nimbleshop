class PaymentMethod::PaypalWebsitePaymentsStandard < PaymentMethod
  store_accessor  :settings, :paypal_website_payments_standard_merchant_email,
                  :paypal_website_payments_standard_use_ssl,
                  :paypal_website_payments_standard_paymentaction

  def use_ssl
    self.settings[ :paypal_website_payments_standard_use_ssl ]
  end

end
