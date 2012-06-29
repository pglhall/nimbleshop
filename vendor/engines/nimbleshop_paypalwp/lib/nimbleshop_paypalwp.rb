require 'nimbleshop_paypalwp/engine'
require "nimbleshop_paypalwp/active_merchant/billing/integrations/paypal/helper"
require "valid_email"

module NimbleshopPaypalwp
  autoload :Processor, 'nimbleshop_paypalwp/processor'
end
