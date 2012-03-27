class PaymentMethod::PaypalWebsitePaymentsStandard < PaymentMethod
  store_accessor  :settings, :paypal_website_payments_standard_merchant_email, :paypal_website_payments_standard_paymentaction
end
