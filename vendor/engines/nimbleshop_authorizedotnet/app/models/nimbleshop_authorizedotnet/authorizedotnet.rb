module NimbleshopAuthorizedotnet
  class Authorizedotnet < PaymentMethod

    store_accessor :settings, :login_id, :transaction_key, :use_ssl, :company_name_on_creditcard_statement, :mode

    before_save :set_mode

    validates_presence_of :login_id, :transaction_key, :company_name_on_creditcard_statement

    def credentials
      { login: login_id, password: transaction_key }
    end

    private

    def set_mode
      self.mode ||= 'test'
    end

  end
end
