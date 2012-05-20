module NimbleshopPaypalwp
  class Paypalwp < PaymentMethod
    store_accessor  :settings, :merchant_email, :paymentaction

    validates :merchant_email, email: true, allow_blank: false
  end
end
