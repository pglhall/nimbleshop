module Payment
  module Handler
    autoload :Base,         'payment/handler/base'
    autoload :Paypal,       'payment/handler/paypal'
    autoload :Splittable,   'payment/handler/splittable'
    autoload :AuthorizeNet, 'payment/handler/authorize_net'
  end
end
