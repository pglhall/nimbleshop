module NimbleshopAuthorizedotnet
  class Authorizedotnet < PaymentMethod

    store_accessor :metadata, :login_id, :transaction_key, :business_name, :mode, :ssl

    before_save :set_mode, :set_ssl

    validates_presence_of :login_id, :transaction_key, :business_name

    def credentials
      { login: login_id, password: transaction_key }
    end

    def use_ssl?
      self.ssl == 'enabled'
    end

    def kapture!(order)
      processor = NimbleshopAuthorizedotnet::Processor.new(order: order, payment_method: self)
      processor.kapture
      order.kapture!
    end

    private

    def set_mode
      self.mode ||= 'test'
    end

    def set_ssl
      self.ssl ||= 'disabled'
    end

  end
end
