class PaymentMethod::PaypalWebsitePaymentsStandard < PaymentMethod
  store_accessor  :settings, :merchant_email, :use_ssl, :paymentaction

end
