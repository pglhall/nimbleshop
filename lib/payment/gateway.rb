module Payment
  module Gateway
    autoload :Paypal,       'payment/gateway/paypal'
    autoload :Splittable,   'payment/gateway/splittable'
    autoload :AuthorizeNet, 'payment/gateway/authorize_net'
  end
end
