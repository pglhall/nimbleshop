module NimbleshopSplitable
  class Splitable < PaymentMethod

    store_accessor :settings, :api_key,
                              :api_secret,
                              :submission_url,
                              :expires_in

    validates_presence_of :api_key
  end
end
