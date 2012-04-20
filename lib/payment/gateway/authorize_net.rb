module Payment
  module Gateway
    class AuthorizeNet
      def self.client
        ActiveMerchant::Billing::AuthorizeNetGateway.new(PaymentMethod::AuthorizeNet.first.credentials)
      end
    end
  end
end
