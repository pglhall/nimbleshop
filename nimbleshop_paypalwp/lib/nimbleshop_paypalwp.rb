require 'nimbleshop_paypalwp/engine'
require 'active_merchant'
require 'active_merchant/billing/integrations/helper'
require "nimbleshop_paypalwp/active_merchant/billing/integrations/paypal/helper"
require "valid_email"
require "money"

module NimbleshopPaypalwp
  autoload :Processor, 'nimbleshop_paypalwp/processor'
end
