module NimbleshopPaypalwp
  class Paypalwp < PaymentMethod

    store_accessor  :metadata, :merchant_email, :mode

    before_save :set_mode

    validates :merchant_email, email: true, presence: true

    before_validation :strip_attributes

    private

    def set_mode
      self.mode ||= 'test'
    end

    # This is needed because https://github.com/nimbleshop/nimbleshop/blob/master/nimbleshop_core/lib/nimbleshop/core_ext/activerecord_base.rb
    # acts only on core attributes and not on store_accessors.
    def strip_attributes
      self.merchant_email = self.merchant_email.strip
    end

  end
end
