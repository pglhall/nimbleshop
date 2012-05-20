module NimbleshopAuthorizedotnet
  class Authorizedotnet < PaymentMethod

    store_accessor :settings, :login_id, :transaction_key, :use_ssl, :company_name_on_creditcard_statement

    validates_presence_of :login_id, :transaction_key, :company_name_on_creditcard_statement

    def credentials
      { login: login_id, password: transaction_key }
    end

  end
end
