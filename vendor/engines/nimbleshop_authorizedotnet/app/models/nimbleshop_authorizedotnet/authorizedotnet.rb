module NimbleshopAuthorizedotnet
  class Authorizedotnet < PaymentMethod

    store_accessor :metadata, :login_id, :transaction_key, :company_name_on_creditcard_statement, :mode, :ssl

    before_save :set_mode, :set_ssl

    validates_presence_of :login_id, :transaction_key, :company_name_on_creditcard_statement

    def credentials
      { login: login_id, password: transaction_key }
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
