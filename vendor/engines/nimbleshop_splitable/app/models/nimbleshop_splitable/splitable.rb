module NimbleshopSplitable
  class Splitable < PaymentMethod

    store_accessor :metadata, :api_key, :api_secret, :expires_in, :mode

    validates_presence_of :api_key

    before_save :set_mode

    private

    def set_mode
      self.mode ||= 'test'
    end
  end
end
