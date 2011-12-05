class Gateway

  # returns the current gateway configured for the shop. Returns nil
  # if no gateway is configured.
  def self.current
    Gateway::AuthorizeNet.instance
  end

  def self.set_mode
    #ActiveMerchant::Billing::Base.mode = Rails.env.production? ? :production : :test
    ActiveMerchant::Billing::Base.mode = :test
  end

end
