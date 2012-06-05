module NimbleshopPaypalwp
  class Paypalwp < PaymentMethod

    store_accessor  :metadata, :merchant_email, :mode

    before_save :set_mode

    validates :merchant_email, email: true, allow_blank: false

    private

    def set_mode
      self.mode ||= 'test'
    end

  end
end
