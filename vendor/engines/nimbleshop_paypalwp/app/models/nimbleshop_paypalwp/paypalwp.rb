module NimbleshopPaypalwp
  class Paypalwp < PaymentMethod
    store_accessor  :settings, :merchant_email, :paymentaction, :mode

    before_save :set_mode

    validates :merchant_email, email: true, allow_blank: false

    private

    def set_mode
      self.mode ||= 'test'
    end
  end
end
