module NimbleshopPaypalwp
  class Paypalwp < PaymentMethod
    store_accessor  :settings, :merchant_email, :paymentaction
  end
end
