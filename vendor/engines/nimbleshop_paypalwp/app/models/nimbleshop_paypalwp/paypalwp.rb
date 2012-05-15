module NimbleshopPaypalwp
  class Paypalwp < PaymentMethod
    store_accessor  :settings, :merchant_email, :use_ssl, :paymentaction
  end
end
