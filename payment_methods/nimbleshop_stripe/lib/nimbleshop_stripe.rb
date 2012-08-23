require 'nimbleshop_stripe/engine'
require 'stripe'

module NimbleshopStripe
  autoload :Processor, 'nimbleshop_stripe/processor'
  autoload :Gateway,   'nimbleshop_stripe/gateway'
  autoload :Util,      'nimbleshop_stripe/util'
end
